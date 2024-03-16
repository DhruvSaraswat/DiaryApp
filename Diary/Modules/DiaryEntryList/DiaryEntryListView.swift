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
    @Query(Constants.fetchDescriptor) private var items: [DiaryEntryItem]

    var body: some View {
        VStack {
            Text("All Diary Entries")
                .font(.title)

            List {
                ForEach(items) { item in
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
}
