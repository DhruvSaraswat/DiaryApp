//
//  HomeViewModel.swift
//  Diary
//
//  Created by Dhruv Saraswat on 12/03/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private var networkEngine: NetworkEngine

    init(networkEngine: NetworkEngine = NetworkEngineImpl()) {
        self.networkEngine = networkEngine
    }

    func fetchAllDiaryEntries(userId: String?) {
        guard let id = userId else { return }

        self.networkEngine.request(request: Request.fetchAllEntries(userId: id)) { (result: Result<[DiaryEntry]?, APIError>) in
            switch result {
            case .success(let diaryEntries):
                print("SUCCESS - diaryEntries = \(String(describing: diaryEntries))")
            case .failure(let failure):
                print("FAULIRE - failure = \(failure)")
            }
        }
    }
}
