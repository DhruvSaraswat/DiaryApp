//
//  DiaryEntryRow.swift
//  Diary
//
//  Created by Dhruv Saraswat on 12/03/24.
//

import Foundation
import SwiftUI

struct DiaryEntryRow: View {
    private var diaryEntryItem: Item

    init(diaryEntryItem: Item) {
        self.diaryEntryItem = diaryEntryItem
    }

    var body: some View {
        NavigationLink(destination: DiaryEntryView().environmentObject(DiaryEntryViewModel(diaryEntryItem: diaryEntryItem))) {
            VStack(alignment: .leading, spacing: -5) {
                Text(diaryEntryItem.diaryDate)
                    .font(.subheadline)
                    .foregroundStyle(Constants.Colors.dateTextColor)
                    .bold()

                Text(diaryEntryItem.title)
                    .font(.title)
                    .foregroundStyle(Color.black)
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        }
        .listRowSeparator(.hidden)
        .listRowBackground(
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundStyle(Color(UIColor(red: 242 / 255, green: 231 / 255, blue: 225 / 255, alpha: 1)))
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 40))
        )
    }
}
