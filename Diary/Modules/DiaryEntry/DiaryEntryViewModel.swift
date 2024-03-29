//
//  DiaryEntryViewModel.swift
//  Diary
//
//  Created by Dhruv Saraswat on 11/03/24.
//

import Foundation
import SwiftData

final class DiaryEntryViewModel: ObservableObject {
    @Published var diaryEntryItem: Item

    private var networkEngine: NetworkEngine

    init(diaryEntryItem: Item, networkEngine: NetworkEngine = NetworkEngineImpl()) {
        self.diaryEntryItem = diaryEntryItem
        self.networkEngine = networkEngine
    }

    func saveDiaryEntry(userId: String?, calendarViewModel: CalendarViewModel) {
        guard let id = userId else { return }

        guard !diaryEntryItem.title.isEmpty && !diaryEntryItem.story.isEmpty else {
            return
        }

        let diaryEntry = DiaryEntry(title: diaryEntryItem.title,
                                    story: diaryEntryItem.story,
                                    diaryTimestamp: diaryEntryItem.diaryTimestamp,
                                    createdAtTimestamp: diaryEntryItem.createdAtTimestamp,
                                    lastEditedAtTimestamp: diaryEntryItem.lastEditedAtTimestamp)

        Task {
            let apiResult: Result<[DiaryEntry]?, APIError> = await networkEngine.request(request: Request.saveDiaryEntry(userId: id, diaryEntry: diaryEntry))
        }
    }
}
