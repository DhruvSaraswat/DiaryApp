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

    func fetchAllDiaryEntries(userId: String) async -> (isSuccessful: Bool, items: [DiaryEntryItem]) {
        guard !userId.isEmpty else {
            return (false, [])
        }

        let apiResult: Result<[DiaryEntry]?, APIError> = await networkEngine.request(request: Request.fetchAllEntries(userId: userId))

        switch apiResult {
        case .success(let diaryEntries):
            print("SUCCESS - diaryEntries = \(String(describing: diaryEntries))")
            var items: [DiaryEntryItem] = []
            for diaryEntry in diaryEntries ?? [] {
                let diaryTimestamp: Int64 = diaryEntry.diaryTimestamp ?? Int64(Date.now.timeIntervalSince1970)
                let diaryDate = diaryTimestamp.getDisplayDateForDiaryEntry()

                let diaryEntryItem = DiaryEntryItem(title: diaryEntry.title ?? "",
                                                    story: diaryEntry.story ?? "",
                                                    diaryTimestamp: diaryTimestamp,
                                                    diaryDate: diaryDate,
                                                    createdAtTimestamp: diaryEntry.createdAtTimestamp ?? Int64(Date.now.timeIntervalSince1970),
                                                    lastEditedAtTimestamp: diaryEntry.lastEditedAtTimestamp ?? Int64(Date.now.timeIntervalSince1970))
                items.append(diaryEntryItem)
            }
            return (true, items)

        case .failure(let failure):
            print("FAILURE - failure = \(failure)")
            return (false, [])
        }
    }

    func deleteDiaryEntry(userId: String, diaryTimestamp: Int64) async {
        guard !userId.isEmpty else {
            return
        }

        let _: Result<[DiaryEntry]?, APIError> = await networkEngine.request(request: Request.deleteEntry(userId: userId, diaryTimestamp: diaryTimestamp))
    }
}
