//
//  DiaryEntryViewModel.swift
//  Diary
//
//  Created by Dhruv Saraswat on 11/03/24.
//

import Foundation
import SwiftData

final class DiaryEntryViewModel: ObservableObject {
    @Published var diaryEntryItem: DiaryEntryItem

    private var networkEngine: NetworkEngine

    init(diaryEntryItem: DiaryEntryItem,
         networkEngine: NetworkEngine = NetworkEngineImpl()) {
        self.diaryEntryItem = diaryEntryItem
        self.networkEngine = networkEngine
    }

    func saveDiaryEntry(userId: String?) async {
        guard let id = userId else { return }

        guard !diaryEntryItem.title.isEmpty && !diaryEntryItem.story.isEmpty else {
            return
        }

        let diaryEntry = DiaryEntry(title: diaryEntryItem.title,
                                    story: diaryEntryItem.story,
                                    diaryTimestamp: diaryEntryItem.diaryTimestamp,
                                    createdAtTimestamp: diaryEntryItem.createdAtTimestamp,
                                    lastEditedAtTimestamp: diaryEntryItem.lastEditedAtTimestamp)

        let _: Result<[DiaryEntry]?, APIError> = await networkEngine.request(request: Request.saveDiaryEntry(userId: id, diaryEntry: diaryEntry))
    }
}
