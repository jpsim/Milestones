import SwiftUI

extension Array where Element == Milestone {
    static var mock: Self {
        [
            Milestone(title: "🍎 WWDC", month: 6, day: 22),
            Milestone(title: "🇨🇦 Canada Day", month: 7, day: 1),
            Milestone(title: "🇺🇸 Independence Day", month: 7, day: 4),
        ]
    }
}

private extension Milestone {
    init(title: String, month: Int, day: Int) {
        self.id = UUID()
        self.title = title
        self.date = DateComponents(calendar: .current, year: 2020, month: month, day: day).date!
        self.today = Date()
        self.calendar = .current
        self.isEditing = false
    }
}
