//
//  CachedDataHandler.swift
//  Diary
//
//  Created by Dhruv Saraswat on 30/03/24.
//

import SwiftData
import SwiftUI

@ModelActor
actor CachedDataHandler {
    @MainActor
    public init(modelContainer: ModelContainer, mainActor _: Bool) {
        let modelContext = modelContainer.mainContext
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
    }

    func persist(diaryEntries: [DiaryEntryItem]) throws {
        diaryEntries.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func delete(diaryEntry: DiaryEntryItem) throws {
        modelContext.delete(diaryEntry)
        try modelContext.save()
    }

    // TODO: Try making this function generic
    func deleteAllItems() throws {
        try modelContext.delete(model: DiaryEntryItem.self)
        try modelContext.save()
    }
}

struct CachedDataHandlerKey: EnvironmentKey {
    static let defaultValue: @Sendable @MainActor () async -> CachedDataHandler? = { nil }
}

extension EnvironmentValues {
  var createCachedDataHandler: @Sendable @MainActor () async -> CachedDataHandler? {
    get { self[CachedDataHandlerKey.self] }
    set { self[CachedDataHandlerKey.self] = newValue }
  }
}
