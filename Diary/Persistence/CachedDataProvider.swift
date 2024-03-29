//
//  CachedDataProvider.swift
//  Diary
//
//  Created by Dhruv Saraswat on 30/03/24.
//

import SwiftData

final class CachedDataProvider {
    static let shared = CachedDataProvider()

    private init() { }

    lazy var sharedModelContainer: ModelContainer = {
      let schema = Schema(CurrentScheme.models)
      let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

      do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
      } catch {
        fatalError("Could not create ModelContainer: \(error)")
      }
    }()

    lazy var previewContainer: ModelContainer = {
      let schema = Schema(CurrentScheme.models)
      let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
      do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
      } catch {
        fatalError("Could not create ModelContainer: \(error)")
      }
    }()

    func createCachedDataHandler(preview: Bool = false) -> @Sendable @MainActor () async -> CachedDataHandler {
      let container = preview ? previewContainer : sharedModelContainer
      return { CachedDataHandler(modelContainer: container, mainActor: true) }
    }
}
