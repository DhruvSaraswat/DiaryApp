//
//  PersistentDataHandler.swift
//  Diary
//
//  Created by Dhruv Saraswat on 27/03/24.
//

import Foundation
import SwiftData

@ModelActor
actor PersistentDataHandler {

    @MainActor
    init(modelContainer: ModelContainer, mainActor _: Bool) {
      let modelContext = modelContainer.mainContext
      modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
      self.modelContainer = modelContainer
    }

    func fetch(byDescriptor descriptor: FetchDescriptor<Item>) throws -> [Item] {
        return try modelContext.fetch(descriptor)
    }

    @discardableResult
    func upsert(item: Item) throws -> PersistentIdentifier {
        debugPrint("UPSERTING ITEM - title = \(item.title), story = \(item.story)")
        modelContext.insert(item)
        debugPrint("AFTER UPSERTING ITEM - title = \(item.title), story = \(item.story), modelContext.hasChanges \(modelContext.hasChanges)")
        try modelContext.save()
        debugPrint("SUCCESSFULLY UPSERTED ITEM - title = \(item.title), story = \(item.story), item.persistentModelID = \(item.persistentModelID)")
        return item.persistentModelID
    }

    func deleteItem(id: PersistentIdentifier) throws {
        guard let item = self[id, as: Item.self] else { return }
        modelContext.delete(item)
        try modelContext.save()
    }

    func deleteAllItems() throws {
        try modelContext.delete(model: Item.self)
    }
    
}
