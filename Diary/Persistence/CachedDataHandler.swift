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

    @discardableResult
    func persist(diaryEntry: DiaryEntryItem) throws -> PersistentIdentifier {
        modelContext.insert(diaryEntry)
        try modelContext.save()
        return diaryEntry.persistentModelID
    }

    func delete<T: PersistentModel>(id: PersistentIdentifier, ofType type: T.Type) throws {
        guard let item = self[id, as: type] else { return }
        modelContext.delete(item)
        try modelContext.save()
    }

    func deleteAllItems<T: PersistentModel>(ofType type: T.Type) throws {
        try modelContext.delete(model: type)
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
