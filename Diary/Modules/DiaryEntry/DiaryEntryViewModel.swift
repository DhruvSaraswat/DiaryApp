//
//  DiaryEntryViewModel.swift
//  Diary
//
//  Created by Dhruv Saraswat on 11/03/24.
//

import Foundation

final class DiaryEntryViewModel: ObservableObject {
    @Published var diaryEntryItem: DiaryEntryItem

    private var networkEngine: NetworkEngine

    init(diaryEntryItem: DiaryEntryItem,
         networkEngine: NetworkEngine = NetworkEngineImpl()) {
        self.diaryEntryItem = diaryEntryItem
        self.networkEngine = networkEngine
    }

    func saveDiaryEntry(userId: String?) {
        guard let id = userId else { return }

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
