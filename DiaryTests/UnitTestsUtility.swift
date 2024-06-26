//
//  UnitTestsUtility.swift
//  DiaryTests
//
//  Created by Dhruv Saraswat on 23/03/24.
//

import Foundation
@testable import Diary

enum RandomStringDomain {
    /// contains English alphabets (uppercase and lowercase) and digits 0 through 9.
    case alphanumeric

    /// contains English alphabets (uppercase and lowercase) only.
    case alphabets

    /// contains digits 0 through 9 only.
    case digits
}

class UnitTestsUtility {
    
    static func generateRandomString(domain: RandomStringDomain, ofLength length: Int) -> String {
        if length <= 0 {
            return ""
        }
        var domainString: NSString = ""
        
        switch domain {
        case .alphanumeric:
            domainString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        case .alphabets:
            domainString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case .digits:
            domainString = "0123456789"
        }
        
        let len = UInt32(domainString.length)
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = domainString.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }

    static func generateRandomDiaryEntryItem() -> DiaryEntryItem {
        DiaryEntryItem(title: generateRandomString(domain: .alphanumeric, ofLength: 10),
                       story: generateRandomString(domain: .alphanumeric, ofLength: 10),
                       diaryTimestamp: Int64.random(in: 0..<1_000_000),
                       diaryDate: generateRandomString(domain: .alphanumeric, ofLength: 10),
                       createdAtTimestamp: Int64.random(in: 0..<1_000_000),
                       lastEditedAtTimestamp: Int64.random(in: 0..<1_000_000))
    }
}
