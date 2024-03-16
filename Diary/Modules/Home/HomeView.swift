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
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(Persistence.fetchDescriptor) private var items: [DiaryEntryItem]
    @State private var selectedDate: Date = Date.now
    private let user = GIDSignIn.sharedInstance.currentUser

    var body: some View {
        NavigationStack {
            VStack {
                CalendarView(selectedDate: $selectedDate)
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

                List {
                    ForEach(items.prefix(2)) { item in
                        DiaryEntryRow(diaryDate: item.diaryDate, title: item.title)
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .foregroundStyle(Color(UIColor(red: 242 / 255, green: 231 / 255, blue: 225 / 255, alpha: 1)))
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: -20))
                        )
                    }
                }
                .listStyle(.plain)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                .scrollDisabled(true)

                Spacer()

                NavigationLink {
                    DiaryEntryView()
                        .environmentObject(
                            createDiaryEntryViewModel(diaryEntryItem: fetchDiaryEntryItem(diaryDate: selectedDate.getDisplayDateForDiaryEntry()))
                            )
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .tint(Color.brown)
                }
            }
        }
        .onAppear(perform: {
            homeViewModel.fetchAllDiaryEntries(userId: viewModel.getUserId(), context: modelContext)
        })
    }

    private func createDiaryEntryViewModel(diaryEntryItem: DiaryEntryItem?) -> DiaryEntryViewModel {
        if let item = diaryEntryItem {
            return DiaryEntryViewModel(diaryEntryItem: item)
        }
        let diaryTimestamp: Int64 = Int64(selectedDate.timeIntervalSince1970)
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
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(HomeViewModel())
}
