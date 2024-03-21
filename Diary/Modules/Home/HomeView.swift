//
//  HomeView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 23/02/24.
//

import SwiftUI
import GoogleSignIn
import SwiftData

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(Persistence.fetchDescriptor) private var items: [DiaryEntryItem]
    private let user = GIDSignIn.sharedInstance.currentUser
    @State private var show2RecentEntries: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: -10) {
                CalendarView(calendar: calendarViewModel.calendar, selectedDate: $calendarViewModel.selectedDate)
                    .frame(height: 400)

                HStack(alignment: .lastTextBaseline) {
                    Text("Recent Entries")
                        .font(.title)
                        .fontWeight(.regular)
                        .padding()

                    Spacer()

                    NavigationLink {
                        DiaryEntryListView()
                    } label: {
                        Text("See All")
                            .font(.callout)
                            .foregroundStyle(Color.brown)
                            .padding()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

                if show2RecentEntries {
                    List {
                        ForEach(items.prefix(2)) { item in
                            DiaryEntryRow(diaryEntryItem: item)
                        }
                        .onDelete(perform: deleteDiaryItems)
                    }
                    .listStyle(.plain)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                }

                Spacer()

                NavigationLink {
                    DiaryEntryView()
                        .environmentObject(
                            createDiaryEntryViewModel(diaryEntryItem: fetchDiaryEntryItem(diaryDate: calendarViewModel.selectedDate.getDisplayDateForDiaryEntry()))
                            )
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .tint(Color.brown)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        authViewModel.signOut(modelContext)
                    }, label: {
                        Text("Sign Out")
                            .font(.callout)
                            .foregroundStyle(Constants.Colors.backArrowTint)
                    })
                }

                ToolbarItem(placement: .principal) {
                    Text("Diary")
                        .foregroundStyle(Constants.Colors.backArrowTint)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: {
            homeViewModel.fetchAllDiaryEntries(userId: authViewModel.getUserId(), context: modelContext) { isSuccessful in
                show2RecentEntries = true
                /// show the dot below all the calendar dates for which a diary entry exists
                DispatchQueue.main.async {
                    calendarViewModel.calendar.reloadData()
                }
            }
        })
    }

    private func createDiaryEntryViewModel(diaryEntryItem: DiaryEntryItem?) -> DiaryEntryViewModel {
        if let item = diaryEntryItem {
            return DiaryEntryViewModel(diaryEntryItem: item)
        }
        let diaryTimestamp: Int64 = Int64(calendarViewModel.selectedDate.timeIntervalSince1970)
        let diaryDate = diaryTimestamp.getDisplayDateForDiaryEntry()

        let newDiaryEntry = DiaryEntryItem(title: "",
                                           story: "",
                                           diaryTimestamp: diaryTimestamp,
                                           diaryDate: diaryDate,
                                           createdAtTimestamp: Int64(Date.now.timeIntervalSince1970),
                                           lastEditedAtTimestamp: Int64(Date.now.timeIntervalSince1970))
        return DiaryEntryViewModel(diaryEntryItem: newDiaryEntry)
    }

    private func fetchDiaryEntryItem(diaryDate: String) -> DiaryEntryItem? {
        let descriptor = Persistence.getFetchDescriptor(byDiaryDate: diaryDate)
        return try? modelContext.fetch(descriptor).first
    }

    func deleteDiaryItems(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
                homeViewModel.deleteDiaryEntry(userId: authViewModel.getUserId(), diaryTimestamp: items[index].diaryTimestamp, completion: nil)
            }
            /// hide the dot below all the calendar dates for which a diary entry has been deleted
            DispatchQueue.main.async {
                calendarViewModel.calendar.reloadData()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(HomeViewModel())
}
