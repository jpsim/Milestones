import SwiftUI

struct CalendarMonthView: View {
    let calendar: Calendar
    let startDate: Date
    let endDate: Date

    let monthOffset: Int

    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
    var monthsArray: [[Date]] {
        monthArray()
    }
    let cellWidth = CGFloat(32)

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(getMonthHeader())
            VStack(alignment: .leading, spacing: 5) {
                ForEach(monthsArray, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { column in
                            HStack {
                                Spacer()
                                if self.isThisMonth(date: column) {
                                    RKCell(rkDate: RKDate(
                                        date: column,
                                        calendar: self.calendar,
                                        isDisabled: !self.isEnabled(date: column),
                                        isBetweenStartAndEnd: false),
                                        cellWidth: self.cellWidth)
                                } else {
                                    Text("").frame(width: self.cellWidth, height: self.cellWidth)
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

    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            for column in 0 ... 6 {
                let abc = getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }

    func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy LLLL", options: 0, locale: calendar.locale)

        return headerDateFormatter.string(from: firstOfMonthForOffset()).uppercased()
    }

    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset

        return calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }

    func numberOfDays(offset: Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)

        return (rangeOfWeeks?.count)! * daysPerWeek
    }

    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset

        return calendar.date(byAdding: offset, to: RKFirstDateMonth())!
    }

    func RKFormatDate(date: Date) -> Date {
        let components = calendar.dateComponents(calendarUnitYMD, from: date)

        return calendar.date(from: components)!
    }

    func RKFormatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = RKFormatDate(date: referenceDate)
        let clampedDate = RKFormatDate(date: date)
        return refDate == clampedDate
    }

    func RKFirstDateMonth() -> Date {
        var components = calendar.dateComponents(calendarUnitYMD, from: startDate)
        components.day = 1

        return calendar.date(from: components)!
    }

    // MARK: - Date Property Checkers

    func isEnabled(date: Date) -> Bool {
        let clampedDate = RKFormatDate(date: date)
        if calendar.compare(clampedDate, to: startDate, toGranularity: .day) == .orderedAscending || calendar.compare(clampedDate, to: endDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
}
