//
//  Persistence.swift
//  Diary
//
//  Created by Dhruv Saraswat on 16/03/24.
//

import SwiftData
import SwiftUI

struct Persistence {
    static var fetchDescriptor: FetchDescriptor<Item> = {
        let descriptor = FetchDescriptor<Item>(
            sortBy: [.init(\.diaryTimestamp, order: .reverse)]
        )
        return descriptor
    }()

    static func getFetchDescriptor(byDiaryDate diaryDate: String) -> FetchDescriptor<Item> {
        var descriptor = FetchDescriptor<Item>(predicate: #Predicate { $0.diaryDate == diaryDate })
        descriptor.fetchLimit = 1
        return descriptor
    }
}
