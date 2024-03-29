//
//  SchemaV1.swift
//  Diary
//
//  Created by Dhruv Saraswat on 27/03/24.
//

import Foundation
import SwiftData

typealias CurrentSchema = SchemaV1

enum SchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [DiaryEntryItem.self]
    }

    static var versionIdentifier: Schema.Version {
        .init(1, 0, 0)
    }
}
