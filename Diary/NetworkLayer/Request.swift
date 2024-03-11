//
//  Request.swift
//  Diary
//
//  Created by Dhruv Saraswat on 11/03/24.
//

import Foundation

enum Request: APIRequest {
    case saveDiaryEntry(userId: String, diaryEntry: DiaryEntry)
    case fetchAllEntries(userId: String)
    case deleteEntry(userId: String, diaryTimestamp: Int64)

    var scheme: String {
        "http"
    }

    var baseURL: String {
        "localhost"
    }

    var path: String {
        "/api/v1/diary"
    }

    var port: Int? {
        8080
    }

    var headers: [String: String]? {
        switch self {
        case .saveDiaryEntry(let userId, _):
            return ["userId": userId, "Content-Type": "application/json"]

        case .fetchAllEntries(let userId):
            return ["userId": userId]

        case .deleteEntry(let userId, _):
            return ["userId": userId]
        }
    }

    var queryParameters: [URLQueryItem]? {
        switch self {
        case .saveDiaryEntry:
            return nil

        case .fetchAllEntries:
            return nil

        case .deleteEntry(_, let diaryTimestamp):
            return [URLQueryItem(name: "diaryTimestamp", value: "\(diaryTimestamp)")]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .saveDiaryEntry:
            return HTTPMethod.post

        case .fetchAllEntries:
            return HTTPMethod.get

        case .deleteEntry:
            return HTTPMethod.delete
        }
    }

    var requestBody: [String: Any]? {
        switch self {
        case .saveDiaryEntry(_, let diaryEntry):
            return ["title": diaryEntry.title,
                    "story": diaryEntry.story,
                    "diaryTimestamp": diaryEntry.diaryTimestamp,
                    "createdAtTimestamp": diaryEntry.createdAtTimestamp,
                    "lastEditedAtTimestamp": diaryEntry.lastEditedAtTimestamp]
            
        case .fetchAllEntries:
            return nil

        case .deleteEntry:
            return nil
        }
    }
}
