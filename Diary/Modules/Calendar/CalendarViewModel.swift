//
//  CalendarViewModel.swift
//  Diary
//
//  Created by Dhruv Saraswat on 19/03/24.
//

import Foundation
import FSCalendar
import SwiftData

final class CalendarViewModel: NSObject, ObservableObject {
    @Published var calendar = FSCalendar()
    @Published var selectedDate: Date = Date.now
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        super.init()
        calendar.delegate = self
        calendar.dataSource = self
    }
}

extension CalendarViewModel: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
    }
}

extension CalendarViewModel: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let diaryDate = date.getDisplayDateForDiaryEntry()
        let descriptor = Persistence.getFetchDescriptor(byDiaryDate: diaryDate)
        do {
            return try modelContext.fetchCount(descriptor)
        } catch {
            return 0
        }
    }
}
