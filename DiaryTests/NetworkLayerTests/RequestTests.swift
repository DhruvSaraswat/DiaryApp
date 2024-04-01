//
//  RequestTests.swift
//  DiaryTests
//
//  Created by Dhruv Saraswat on 23/03/24.
//

import XCTest
@testable import Diary

final class RequestTests: XCTestCase {

    var sut: Request!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func test_deleteEntryRequest() {
        let randomUserId = UnitTestsUtility.generateRandomString(domain: .alphanumeric, ofLength: 10)
        let timestamp = Int64(Date.now.timeIntervalSince1970)
        sut = Request.deleteEntry(userId: randomUserId, diaryTimestamp: timestamp)
        XCTAssertEqual(sut.scheme, "http")
        XCTAssertEqual(sut.baseURL, "localhost")
        XCTAssertEqual(sut.path, "/api/v1/diary")
        XCTAssertEqual(sut.headers, ["userId": randomUserId])
        XCTAssertEqual(sut.queryParameters, [URLQueryItem(name: "diaryTimestamp", value: "\(timestamp)")])
        XCTAssertEqual(sut.method, HTTPMethod.delete)
        XCTAssertNil(sut.requestBody)
    }

    func test_fetchAllEntriesRequest() {
        let randomUserId = UnitTestsUtility.generateRandomString(domain: .alphanumeric, ofLength: 10)
        sut = Request.fetchAllEntries(userId: randomUserId)
        XCTAssertEqual(sut.scheme, "http")
        XCTAssertEqual(sut.baseURL, "localhost")
        XCTAssertEqual(sut.path, "/api/v1/diary")
        XCTAssertEqual(sut.headers, ["userId": randomUserId])
        XCTAssertNil(sut.queryParameters)
        XCTAssertEqual(sut.method, HTTPMethod.get)
        XCTAssertNil(sut.requestBody)
    }

    func test_saveDiaryEntryRequest() {
        let randomUserId = UnitTestsUtility.generateRandomString(domain: .alphanumeric, ofLength: 10)
        let randomDiaryEntry = createRandomDiaryEntry()
        sut = Request.saveDiaryEntry(userId: randomUserId, diaryEntry: randomDiaryEntry)
        XCTAssertEqual(sut.scheme, "http")
        XCTAssertEqual(sut.baseURL, "localhost")
        XCTAssertEqual(sut.path, "/api/v1/diary")
        XCTAssertEqual(sut.headers, ["userId": randomUserId, "Content-Type": "application/json"])
        XCTAssertNil(sut.queryParameters)
        XCTAssertEqual(sut.method, HTTPMethod.post)

        let expectedRequestBody: [String: Any] = ["title": randomDiaryEntry.title,
                                                  "story": randomDiaryEntry.story,
                                                  "diaryTimestamp": randomDiaryEntry.diaryTimestamp,
                                                  "createdAtTimestamp": randomDiaryEntry.createdAtTimestamp,
                                                  "lastEditedAtTimestamp": randomDiaryEntry.lastEditedAtTimestamp]
        let actualRequestBody = sut.requestBody
        XCTAssertEqual(actualRequestBody?.count, expectedRequestBody.count)
        XCTAssertEqual(actualRequestBody?["title"] as? String, expectedRequestBody["title"] as? String)
        XCTAssertEqual(actualRequestBody?["story"] as? String, expectedRequestBody["story"] as? String)
        XCTAssertEqual(actualRequestBody?["diaryTimestamp"] as? String, expectedRequestBody["diaryTimestamp"] as? String)
        XCTAssertEqual(actualRequestBody?["createdAtTimestamp"] as? String, expectedRequestBody["createdAtTimestamp"] as? String)
        XCTAssertEqual(actualRequestBody?["lastEditedAtTimestamp"] as? String, expectedRequestBody["lastEditedAtTimestamp"] as? String)
    }

    private func createRandomDiaryEntry() -> DiaryEntry {
        DiaryEntry(title: UnitTestsUtility.generateRandomString(domain: .alphanumeric, ofLength: 10),
                   story: UnitTestsUtility.generateRandomString(domain: .alphanumeric, ofLength: 10),
                   diaryTimestamp: Int64(Date.now.timeIntervalSince1970),
                   createdAtTimestamp: Int64(Date.now.timeIntervalSince1970),
                   lastEditedAtTimestamp: Int64(Date.now.timeIntervalSince1970))
    }

}
