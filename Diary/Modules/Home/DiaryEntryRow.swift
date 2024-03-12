//
//  DiaryEntryRow.swift
//  Diary
//
//  Created by Dhruv Saraswat on 12/03/24.
//

import Foundation
import SwiftUI

struct DiaryEntryRow: View {
    private var date: Date
    private var title: String

    init(date: Date, title: String) {
        self.date = date
        self.title = title
    }

    var body: some View {
        VStack(alignment: .leading, spacing: -5) {
            Text("\(date.getDisplayDateForDiaryEntry())")
                .font(.subheadline)
                .foregroundStyle(Constants.Colors.diaryEntryRowBackgroundColor)
                .bold()

            Text(title)
                .font(.title)
                .foregroundStyle(Color.black)
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

#Preview {
    DiaryEntryRow(date: Date.now, title: "Today was a good day")
}