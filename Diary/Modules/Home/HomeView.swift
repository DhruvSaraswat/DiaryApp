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
    @Query private var items: [DiaryEntryItem]
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

                    Button(action: {}, label: {
                        Text("See All")
                            .font(.callout)
                            .foregroundStyle(Color.brown)
                            .padding()
                    })
                }

                List {
                    ForEach(items.prefix(2)) { item in
                        if let timestamp = item.diaryTimestamp, let title = item.title {
                            DiaryEntryRow(date: Date(timeIntervalSince1970: Double(timestamp)),
                                          title: title)
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .foregroundStyle(Color(UIColor(red: 242 / 255, green: 231 / 255, blue: 225 / 255, alpha: 1)))
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: -20)))
                        }
                    }
                }
                .listStyle(.plain)
                //.listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))

                Spacer()

                NavigationLink {
                    DiaryEntryView()
                        .environmentObject(DiaryEntryViewModel(title: "",
                                                               story: "",
                                                               diaryDate: selectedDate,
                                                               createdAtDate: Date.now,
                                                               lastEditedAtDate: Date.now))
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
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(HomeViewModel())
}
