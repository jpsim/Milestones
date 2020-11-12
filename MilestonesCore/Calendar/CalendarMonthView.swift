import SwiftUI

struct CalendarMonthView: View {
    let calendar: Calendar
    let startDate: Date
    let endDate: Date

    let monthOffsetFromStartDate: Int

    let daysPerWeek = 7
    let cellWidth = CGFloat(32)

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(getMonthHeader())
            VStack(alignment: .leading, spacing: 5) {
                ForEach(dateGrid(), id: \.self) { rowOfDates in
                    HStack {
                        ForEach(rowOfDates, id: \.self) { date in
                            HStack {
                                Spacer()
                                if self.isThisMonth(date: date) {
                                    CalendarDateView(
                                        state: .init(
                                            date: date,
                                            calendar: self.calendar,
                                            isDisabled: !self.isEnabled(date: date)
                                        )
                                    )
                                    .frame(width: self.cellWidth, height: self.cellWidth)
                                } else {
                                    EmptyView()
                                        .frame(width: self.cellWidth, height: self.cellWidth)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }

     func isThisMonth(date: Date) -> Bool {
         return calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month)
     }

    func dateGrid() -> [[Date]] {
        return (0 ..< (numberOfDaysInMonth() / daysPerWeek)).compactMap { row in
            return (0 ... 6).compactMap { column in
                dateAtIndex(index: (row * daysPerWeek) + column)
            }
        }
    }

    func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter(
            calendar: calendar,
            dateFormat: DateFormatter.dateFormat(
                fromTemplate: "yyyy LLLL", options: 0, locale: calendar.locale
            )
        )

        return headerDateFormatter
            .string(from: firstOfMonthForOffset())
            .uppercased()
    }

    func dateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        let dateComponents = DateComponents(day: index - startOffset)

        return calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }

    func numberOfDaysInMonth() -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)!
        return rangeOfWeeks.count * daysPerWeek
    }

    func firstOfMonthForOffset() -> Date {
        let offset = DateComponents(month: monthOffsetFromStartDate)
        return calendar.date(byAdding: offset, to: calendar.firstDayOfMonth(for: startDate))!
    }

    // MARK: - Date Property Checkers

    func isEnabled(date: Date) -> Bool {
        calendar.isDay(date, between: startDate, and: endDate)
    }
}

struct CalendarMonthView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMonthView(
            calendar: .current,
            startDate: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 2),
            endDate: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            monthOffsetFromStartDate: 0
        )
        .previewLayout(.sizeThatFits)
    }
}
