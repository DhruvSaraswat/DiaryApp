//
//  DiaryEntryRow.swift
//  Diary
//
//  Created by Dhruv Saraswat on 12/03/24.
//

import Foundation
import SwiftUI

struct DiaryEntryRow: View {
    private var diaryEntryItem: DiaryEntryItem

    init(diaryEntryItem: DiaryEntryItem) {
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
    }
}
