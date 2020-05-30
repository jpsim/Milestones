import Foundation

extension Calendar {
    func firstDayOfMonth(for date: Date) -> Date {
        var components = dateComponents([.year, .month, .day], from: date)
        components.day = 1
        return self.date(from: components)!
    }

    func isDay(_ day: Date, between firstDay: Date, and secondDay: Date) -> Bool {
        if compare(day, to: firstDay, toGranularity: .day) == .orderedAscending {
            return false
        } else if compare(day, to: secondDay, toGranularity: .day) == .orderedDescending {
            return false
        } else {
            return true
        }
    }

    func numberOfCalendarMonthsIncluding(startDate: Date, endDate: Date) -> Int {
        return dateComponents([.month], from: startDate, to: firstDayOfMonth(after: endDate)).month! + 1
    }

    private func firstDayOfMonth(after date: Date) -> Date {
        var components = dateComponents([.year, .month, .day], from: date)
        components.month! += 1
        components.day = 0
        return self.date(from: components)!
    }
}
