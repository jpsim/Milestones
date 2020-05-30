import SwiftUI

struct CalendarDate {
    var date: Date
    let calendar: Calendar

    var isDisabled: Bool
    var isBetweenStartAndEnd: Bool

    func getText() -> String {
        return formatDate(date: date, calendar: calendar)
    }

    func getTextColor() -> Color {
        if isDisabled {
            return .gray
        } else if isBetweenStartAndEnd {
            return .white
        } else {
            return .primary
        }
    }

    func getFontWeight() -> Font.Weight {
        if isDisabled {
            return .thin
        } else if isBetweenStartAndEnd {
            return .heavy
        } else {
            return .medium
        }
    }

    // MARK: - Date Formats

    func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = dateFormatter()
        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }

    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter
    }

    func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
}
