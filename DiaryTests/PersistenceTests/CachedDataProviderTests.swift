//
//  CachedDataProviderTests.swift
//  DiaryTests
//
//  Created by Dhruv Saraswat on 01/04/24.
//

import XCTest
import SwiftData
@testable import Diary

final class CachedDataProviderTests: XCTestCase {

    @MainActor
    func test_Persist() async throws {
        let container = try ContainerForTest.temp(#function)
        let handler = CachedDataHandler(modelContainer: container)

        let randomDiaryEntryItem = UnitTestsUtility.generateRandomDiaryEntryItem()
        try await handler.persist(diaryEntry: randomDiaryEntryItem)

        let fetchDescriptor = FetchDescriptor<DiaryEntryItem>()
        let items = try container.mainContext.fetch(fetchDescriptor)

        XCTAssertEqual(items.count, 1, "There should be exactly one item in the store.")

        if let firstItem = items.first {
            XCTAssertEqual(firstItem.diaryTimestamp, randomDiaryEntryItem.diaryTimestamp)
            XCTAssertEqual(firstItem.story, randomDiaryEntryItem.story)
            XCTAssertEqual(firstItem.title, randomDiaryEntryItem.title)
            XCTAssertEqual(firstItem.createdAtTimestamp, randomDiaryEntryItem.createdAtTimestamp)
            XCTAssertEqual(firstItem.diaryDate, randomDiaryEntryItem.diaryDate)
            XCTAssertEqual(firstItem.lastEditedAtTimestamp, randomDiaryEntryItem.lastEditedAtTimestamp)
        } else {
          XCTFail("Expected to find an item but none was found.")
        }
    }

    @MainActor
    func test_delete() async throws {
        let container = try ContainerForTest.temp(#function)
        let handler = CachedDataHandler(modelContainer: container)

        let randomDiaryEntryItem = UnitTestsUtility.generateRandomDiaryEntryItem()
        let itemID = try await handler.persist(diaryEntry: randomDiaryEntryItem)

        try await handler.delete(id: itemID, ofType: DiaryEntryItem.self)

        let fetchDescriptor = FetchDescriptor<DiaryEntryItem>()
        let items = try container.mainContext.fetch(fetchDescriptor)

        XCTAssertEqual(items.count, 0, "There should be no item in the store.")
    }

    @MainActor
    func test_deleteAllItems() async throws {
        let container = try ContainerForTest.temp(#function)
        let handler = CachedDataHandler(modelContainer: container)

        let randomDiaryEntryItem1 = UnitTestsUtility.generateRandomDiaryEntryItem()
        try await handler.persist(diaryEntry: randomDiaryEntryItem1)

        let randomDiaryEntryItem2 = UnitTestsUtility.generateRandomDiaryEntryItem()
        try await handler.persist(diaryEntry: randomDiaryEntryItem2)

        let fetchDescriptor = FetchDescriptor<DiaryEntryItem>()
        var items = try container.mainContext.fetch(fetchDescriptor)

        XCTAssertEqual(items.count, 2, "There should be exactly 2 items in the store.")

        try await handler.deleteAllItems(ofType: DiaryEntryItem.self)

        items = try container.mainContext.fetch(fetchDescriptor)

        XCTAssertEqual(items.count, 0, "There should be no item in the store.")
    }

}
