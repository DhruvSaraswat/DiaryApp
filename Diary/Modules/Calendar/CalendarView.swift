//
//  CalendarView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 02/03/24.
//

import FSCalendar
import SwiftUI
import SwiftData

struct CalendarView: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    var calendar: FSCalendar
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> FSCalendar {
        calendar.allowsSelection = true
        calendar.allowsMultipleSelection = false
        calendar.scrollDirection = FSCalendarScrollDirection.horizontal
        calendar.scope = FSCalendarScope.month
        calendar.firstWeekday = 2
        calendar.appearance.todayColor = UIColor.brown
        calendar.appearance.selectionColor = Constants.Colors.selectedDateCircleColor
        calendar.appearance.weekdayTextColor = Constants.Colors.weekdayColor
        calendar.appearance.headerTitleColor = UIColor.brown
        calendar.appearance.borderRadius = 0.5
        calendar.appearance.titleDefaultColor = (colorScheme == .dark) ? UIColor.white : UIColor.black
        calendar.appearance.eventDefaultColor = UIColor.brown.withAlphaComponent(0.5)
        calendar.appearance.eventOffset = CGPoint(x: 0, y: 1)
        calendar.appearance.eventSelectionColor = UIColor.brown
        calendar.appearance.calendar.headerHeight = 30
        calendar.appearance.calendar.weekdayHeight = 40
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.appearance.titleDefaultColor = (colorScheme == .dark) ? UIColor.white : UIColor.black
        calendar.reloadData()
    }
}
