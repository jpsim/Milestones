import Foundation

extension DateFormatter {
    convenience init(calendar: Calendar, dateStyle: DateFormatter.Style = .full, dateFormat: String? = nil) {
        self.init()
        self.calendar = calendar
        self.timeZone = calendar.timeZone
        self.locale = calendar.locale
        self.dateStyle = dateStyle
        if let dateFormat = dateFormat {
            self.dateFormat = dateFormat
        }
    }
}
