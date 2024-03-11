//
//  DiaryEntryViewModel.swift
//  Diary
//
//  Created by Dhruv Saraswat on 11/03/24.
//

import Foundation

final class DiaryEntryViewModel: ObservableObject {
    @Published var title: String = "" {
        didSet {
            lastEditedAtDate = Date.now
        }
    }
    @Published var story: String = "" {
        didSet {
            lastEditedAtDate = Date.now
        }
    }
    let diaryDate: Date
    private let createdAtDate: Date
    private var lastEditedAtDate: Date

    private var networkEngine: NetworkEngine

    init(title: String,
         story: String,
         diaryDate: Date,
         createdAtDate: Date,
         lastEditedAtDate: Date,
         networkEngine: NetworkEngine = NetworkEngineImpl()) {
        self.title = title
        self.story = story
        self.diaryDate = diaryDate
        self.createdAtDate = createdAtDate
        self.lastEditedAtDate = lastEditedAtDate
        self.networkEngine = networkEngine
    }

    func saveDiaryEntry(userId: String?) {
        guard let id = userId else { return }

        let diaryEntry = DiaryEntry(title: title,
                                    story: story,
                                    diaryTimestamp: Int64(diaryDate.timeIntervalSince1970),
                                    createdAtTimestamp: Int64(createdAtDate.timeIntervalSince1970),
                                    lastEditedAtTimestamp: Int64(lastEditedAtDate.timeIntervalSince1970))

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
