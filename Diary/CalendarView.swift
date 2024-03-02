//
//  CalendarView.swift
//  Diary
//
//  Created by Dhruv Saraswat on 02/03/24.
//

import FSCalendar
import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date.now

    init(selectedDate: Date) {
        self.selectedDate = selectedDate
    }

    var body: some View {
        CalenderViewRepresentable(selectedDate: $selectedDate)
    }
}

struct CalenderViewRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    fileprivate var calendar = FSCalendar()
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> FSCalendar {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
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
        calendar.appearance.calendar.headerHeight = 30
        calendar.appearance.calendar.weekdayHeight = 40
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.appearance.titleDefaultColor = (colorScheme == .dark) ? UIColor.white : UIColor.black
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate {
        private var parent: CalenderViewRepresentable

        init(parent: CalenderViewRepresentable) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar,
                      didSelect date: Date,
                      at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
    }
}

#Preview {
    CalendarView(selectedDate: Date.now)
}
