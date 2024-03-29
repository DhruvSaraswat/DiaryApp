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

    func fetchAllDiaryEntries(userId: String, completion: ((_ isSuccessful: Bool, _ items: [Item]) -> Void)?) {
        guard !userId.isEmpty else {
            completion?(false, [])
            return
        }

        Task {
            let apiResult: Result<[DiaryEntry]?, APIError> = await networkEngine.request(request: Request.fetchAllEntries(userId: userId))

            switch apiResult {
            case .success(let diaryEntries):
                print("SUCCESS - diaryEntries = \(String(describing: diaryEntries))")
                var items: [Item] = []
                for diaryEntry in diaryEntries ?? [] {
                    let diaryTimestamp: Int64 = diaryEntry.diaryTimestamp ?? Int64(Date.now.timeIntervalSince1970)
                    let diaryDate = diaryTimestamp.getDisplayDateForDiaryEntry()

                    let diaryEntryItem = Item(title: diaryEntry.title ?? "",
                                              story: diaryEntry.story ?? "",
                                              diaryTimestamp: diaryTimestamp,
                                              diaryDate: diaryDate,
                                              createdAtTimestamp: diaryEntry.createdAtTimestamp ?? Int64(Date.now.timeIntervalSince1970),
                                              lastEditedAtTimestamp: diaryEntry.lastEditedAtTimestamp ?? Int64(Date.now.timeIntervalSince1970))
                    items.append(diaryEntryItem)
                }
                completion?(true, items)

            case .failure(let failure):
                completion?(false, [])
                print("FAILURE - failure = \(failure)")
            }
        }
    }

    func deleteDiaryEntry(userId: String, diaryTimestamp: Int64, completion: ((_ isSuccessful: Bool) -> Void)?) {
        guard !userId.isEmpty else {
            completion?(false)
            return
        }

        Task {
            let _: Result<[DiaryEntry]?, APIError> = await networkEngine.request(request: Request.deleteEntry(userId: userId, diaryTimestamp: diaryTimestamp))
        }
    }
}
