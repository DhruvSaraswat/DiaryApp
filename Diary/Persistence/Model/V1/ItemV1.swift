//
//  ItemV1.swift
//  Diary
//
//  Created by Dhruv Saraswat on 30/03/24.
//

import SwiftData

@Model
final class DiaryEntryItem {
    var title: String
    var story: String
    let diaryTimestamp: Int64
    @Attribute(.unique) let diaryDate: String
    var createdAtTimestamp: Int64
    var lastEditedAtTimestamp: Int64

    init(title: String, story: String, diaryTimestamp: Int64, diaryDate: String, createdAtTimestamp: Int64, lastEditedAtTimestamp: Int64) {
        self.title = title
        self.story = story
        self.diaryTimestamp = diaryTimestamp
        self.diaryDate = diaryDate
        self.createdAtTimestamp = createdAtTimestamp
        self.lastEditedAtTimestamp = lastEditedAtTimestamp
    }
}
