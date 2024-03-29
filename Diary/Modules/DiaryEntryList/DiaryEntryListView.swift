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
    @Query(Persistence.fetchDescriptor, animation: .smooth) private var items: [Item]
    var onDeleteHandler: (IndexSet) -> Void

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
                .onDelete(perform: onDeleteHandler)
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
