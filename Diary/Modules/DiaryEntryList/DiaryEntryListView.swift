//
//  DiaryEntryListView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 15/03/24.
//

import Foundation
import SwiftUI
import SwiftData

struct DiaryEntryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var calendarViewModel: CalendarViewModel
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Query(Persistence.fetchDescriptor) private var items: [DiaryEntryItem]

    var body: some View {
        VStack {
            Text("All Diary Entries")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 0))

            List {
                ForEach(items) { item in
                    DiaryEntryRow(diaryEntryItem: item)
                }
                .onDelete(perform: deleteDiaryItems)
            }
            .listStyle(.plain)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.backward")
                        .tint(Constants.Colors.backArrowTint)
                })
            }
        }
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
