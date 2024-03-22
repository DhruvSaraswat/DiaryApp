//
//  UnitTestsUtility.swift
//  DiaryTests
//
//  Created by Dhruv Saraswat on 23/03/24.
//

import Foundation

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
}
