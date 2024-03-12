//
//  DiaryEntryItem.swift
//  Diary
//
//  Created by Dhruv Saraswat on 12/03/24.
//

import Foundation
import SwiftData

@Model
final class DiaryEntryItem {
    var title: String
    var story: String
    @Attribute(.unique) let diaryTimestamp: Int64
    var createdAtTimestamp: Int64
    var lastEditedAtTimestamp: Int64

    init(title: String, story: String, diaryTimestamp: Int64, createdAtTimestamp: Int64, lastEditedAtTimestamp: Int64) {
        self.title = title
        self.story = story
        self.diaryTimestamp = diaryTimestamp
        self.createdAtTimestamp = createdAtTimestamp
        self.lastEditedAtTimestamp = lastEditedAtTimestamp
    }
}
