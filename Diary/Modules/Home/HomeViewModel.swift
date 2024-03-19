//
//  HomeViewModel.swift
//  Diary
//
//  Created by Dhruv Saraswat on 12/03/24.
//

import Foundation
import SwiftData

final class HomeViewModel: ObservableObject {
    private let networkEngine: NetworkEngine

    init(networkEngine: NetworkEngine = NetworkEngineImpl()) {
        self.networkEngine = networkEngine
    }

    func fetchAllDiaryEntries(userId: String, context: ModelContext, completion: ((_ isSuccessful: Bool) -> Void)?) {
        guard !userId.isEmpty else { return }

        self.networkEngine.request(request: Request.fetchAllEntries(userId: userId)) { (result: Result<[DiaryEntry]?, APIError>) in
            switch result {
            case .success(let diaryEntries):
                print("SUCCESS - diaryEntries = \(String(describing: diaryEntries))")
                for diaryEntry in diaryEntries ?? [] {
                    let diaryTimestamp: Int64 = diaryEntry.diaryTimestamp ?? Int64(Date.now.timeIntervalSince1970)
                    let diaryDate = diaryTimestamp.getDisplayDateForDiaryEntry()
                    
                    let diaryEntryItem = DiaryEntryItem(title: diaryEntry.title ?? "",
                                                        story: diaryEntry.story ?? "",
                                                        diaryTimestamp: diaryTimestamp,
                                                        diaryDate: diaryDate,
                                                        createdAtTimestamp: diaryEntry.createdAtTimestamp ?? Int64(Date.now.timeIntervalSince1970),
                                                        lastEditedAtTimestamp: diaryEntry.lastEditedAtTimestamp ?? Int64(Date.now.timeIntervalSince1970))
                    context.insert(diaryEntryItem)
                }
                completion?(true)

            case .failure(let failure):
                completion?(false)
                print("FAILURE - failure = \(failure)")
            }
        }
    }
}
