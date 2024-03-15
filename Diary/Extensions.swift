//
//  Extensions.swift
//  Diary
//
//  Created by Dhruv Saraswat on 03/03/24.
//

import Foundation

extension Date {
    func getDisplayDateForDiaryEntry() -> String {
        let month = getMonth()
        let day = String(getDayOfMonth())
        let year = String(getYear())

        /// An example return value - "14/March/2024"
        return "\(day)/\(month)/\(year)"
    }

    func getTitleDisplayDate() -> String {
        let weekday = getWeekday()
        let month = getMonth()
        let day = String(getDayOfMonth())
        let year = String(getYear())

        /// An example return value - "Friday, 13 March 2018"
        return "\(weekday), \(day) \(month) \(year)"
    }

    func getWeekday() -> String {
        let calendar: Calendar = Calendar.autoupdatingCurrent
        return calendar.weekdaySymbols[calendar.component(.weekday, from: self) - 1]
    }

    func getMonth() -> String {
        let calendar: Calendar = Calendar.autoupdatingCurrent
        return calendar.monthSymbols[calendar.component(.month, from: self) - 1]
    }

    func getDayOfMonth() -> Int {
        let calendar: Calendar = Calendar.autoupdatingCurrent
        return calendar.component(.day, from: self)
    }

    func getYear() -> Int {
        let calendar: Calendar = Calendar.autoupdatingCurrent
        return calendar.component(.year, from: self)
    }
}

extension Int64 {
    func getTitleDisplayDate() -> String {
        Date(timeIntervalSince1970: Double(self)).getTitleDisplayDate()
    }

    func getDisplayDateForDiaryEntry() -> String {
        Date(timeIntervalSince1970: Double(self)).getDisplayDateForDiaryEntry()
    }
}
