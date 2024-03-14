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
    @Query(HomeView.fetchDescriptor) private var items: [DiaryEntryItem]
    @State private var selectedDate: Date = Date.now
    private let user = GIDSignIn.sharedInstance.currentUser

    static var fetchDescriptor: FetchDescriptor<DiaryEntryItem> {
        let descriptor = FetchDescriptor<DiaryEntryItem>(
            sortBy: [.init(\.diaryTimestamp, order: .reverse)]
        )
        return descriptor
    }

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

                    Button(action: {}, label: {
                        Text("See All")
                            .font(.callout)
                            .foregroundStyle(Color.brown)
                            .padding()
                    })
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

                List {
                    ForEach(items.prefix(2)) { item in
                        DiaryEntryRow(date: Date(timeIntervalSince1970: Double(item.diaryTimestamp)),
                                      title: item.title)
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
                            createDiaryEntryViewModel(diaryEntryItem: fetchDiaryEntryItem(diaryTimestamp: Int64(selectedDate.timeIntervalSince1970)))
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
        let newDiaryEntry = DiaryEntryItem(title: "",
                                           story: "",
                                           diaryTimestamp: Int64(selectedDate.timeIntervalSince1970),
                                           createdAtTimestamp: Int64(Date.now.timeIntervalSince1970),
                                           lastEditedAtTimestamp: Int64(Date.now.timeIntervalSince1970))
        modelContext.insert(newDiaryEntry)
        return DiaryEntryViewModel(diaryEntryItem: newDiaryEntry)
    }

    private func fetchDiaryEntryItem(diaryTimestamp: Int64) -> DiaryEntryItem? {
        var descriptor = FetchDescriptor<DiaryEntryItem>(predicate: #Predicate { $0.diaryTimestamp == diaryTimestamp })
        descriptor.fetchLimit = 1
        return try? modelContext.fetch(descriptor).first
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(HomeViewModel())
}
