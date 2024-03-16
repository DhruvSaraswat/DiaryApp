//
//  Persistence.swift
//  Diary
//
//  Created by Dhruv Saraswat on 16/03/24.
//

import SwiftData
import SwiftUI

struct Persistence {
    static var fetchDescriptor: FetchDescriptor<DiaryEntryItem> = {
        let descriptor = FetchDescriptor<DiaryEntryItem>(
            sortBy: [.init(\.diaryTimestamp, order: .reverse)]
        )
        return descriptor
    }()

    static func getFetchDescriptor(byDiaryDate diaryDate: String) -> FetchDescriptor<DiaryEntryItem> {
        var descriptor = FetchDescriptor<DiaryEntryItem>(predicate: #Predicate { $0.diaryDate == diaryDate })
        descriptor.fetchLimit = 1
        return descriptor
    }
}
