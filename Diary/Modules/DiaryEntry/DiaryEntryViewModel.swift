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

    func saveDiaryEntry(userId: String?, modelContext: ModelContext) {
        guard let id = userId else { return }

        guard !diaryEntryItem.title.isEmpty && !diaryEntryItem.story.isEmpty else {
            return
        }

        modelContext.insert(diaryEntryItem)
        let diaryEntry = DiaryEntry(title: diaryEntryItem.title,
                                    story: diaryEntryItem.story,
                                    diaryTimestamp: diaryEntryItem.diaryTimestamp,
                                    createdAtTimestamp: diaryEntryItem.createdAtTimestamp,
                                    lastEditedAtTimestamp: diaryEntryItem.lastEditedAtTimestamp)

        networkEngine.request(request: Request.saveDiaryEntry(userId: id, diaryEntry: diaryEntry)) { (result: Result<DiaryEntry?, APIError>) in
            switch result {
            case .success:
                // TODO: Show a success toast
                print("SUCCESS")
                
            case .failure(let failure):
                // TODO: Show an error toast
                print("FAILURE")
            }
        }
    }
}
