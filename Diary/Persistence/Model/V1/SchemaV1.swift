//
//  SchemaV1.swift
//  Diary
//
//  Created by Dhruv Saraswat on 30/03/24.
//

import SwiftData

typealias CurrentScheme = SchemaV1

enum SchemaV1: VersionedSchema {
  public static var versionIdentifier: Schema.Version {
    .init(1, 0, 0)
  }

  static var models: [any PersistentModel.Type] {
    [DiaryEntryItem.self]
  }
}
