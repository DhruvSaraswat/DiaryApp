//
//  DiaryEntry.swift
//  Diary
//
//  Created by Dhruv Saraswat on 11/03/24.
//

import Foundation

struct DiaryEntry: Codable {
    let title, story: String?
    let diaryTimestamp, createdAtTimestamp, lastEditedAtTimestamp: Int64?
}
