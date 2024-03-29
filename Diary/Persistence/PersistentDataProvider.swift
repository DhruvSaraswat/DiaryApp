//
//  PersistentDataProvider.swift
//  Diary
//
//  Created by Dhruv Saraswat on 27/03/24.
//

import Foundation
import SwiftData
import SwiftUI

final class PersistentDataProvider {
    static let shared = PersistentDataProvider()

    private init() { }

    let sharedModelContainer: ModelContainer = {
        let schema = Schema(CurrentSchema.models)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Unable to create sharedModelContainer: \(error)")
        }
    }()

    /// Use `previewContainer` instead of `sharedModelContainer` for previews
    let previewContainer: ModelContainer = {
        let schema = Schema(CurrentSchema.models)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Unable to create sharedModelContainer: \(error)")
        }
    }()

    func createHandler(preview: Bool = false) -> @Sendable () async -> PersistentDataHandler {
        let container = preview ? previewContainer : sharedModelContainer
        return { PersistentDataHandler(modelContainer: container) }
    }

    func createHandlerWithMainContext(preview: Bool = false) -> @Sendable @MainActor () async -> PersistentDataHandler {
      let container = preview ? previewContainer : sharedModelContainer
      return { PersistentDataHandler(modelContainer: container, mainActor: true) }
    }
}

struct PersistentDataHandlerKey: EnvironmentKey {
    static let defaultValue: @Sendable () async -> PersistentDataHandler? = { nil }
}

extension EnvironmentValues {
    var createDataHandler: @Sendable () async -> PersistentDataHandler? {
        get { self[PersistentDataHandlerKey.self] }
        set { self[PersistentDataHandlerKey.self] = newValue }
    }
}

struct MainActorPersistentDataHandlerKey: EnvironmentKey {
  public static let defaultValue: @Sendable @MainActor () async -> PersistentDataHandler? = { nil }
}

extension EnvironmentValues {
  var createDataHandlerWithMainContext: @Sendable @MainActor () async -> PersistentDataHandler? {
    get { self[MainActorPersistentDataHandlerKey.self] }
    set { self[MainActorPersistentDataHandlerKey.self] = newValue }
  }
}
