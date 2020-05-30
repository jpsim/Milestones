import Foundation

extension DateFormatter {
    convenience init(calendar: Calendar, dateStyle: DateFormatter.Style = .full, dateFormat: String? = nil) {
        self.init()
        self.calendar = calendar
        self.dateStyle = dateStyle
        if let dateFormat = dateFormat {
            self.dateFormat = dateFormat
        }
    }
}
