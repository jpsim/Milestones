import SwiftUI

// MARK: - View

struct CalendarView: View {
    let calendar: Calendar
    let startDate: Date
    let endDate: Date

    var numberOfMonths: Int {
        return calendar.numberOfCalendarMonthsIncluding(startDate: startDate, endDate: endDate)
    }

    var body: some View {
        VStack {
            CalendarHeaderView(calendar: calendar)
            Divider()
            ScrollView {
                ForEach(0..<numberOfMonths) { index in
                    CalendarMonthView(calendar: self.calendar, startDate: self.startDate, endDate: self.endDate,
                                      monthOffsetFromStartDate: index)
                    Divider()
                }
            }
        }
    }
}

// MARK: - Previews

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(
            calendar: .current,
            startDate: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 8),
            endDate: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 32)
        )
    }
}
