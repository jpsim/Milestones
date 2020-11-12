import Foundation

extension Array where Element == Milestone {
    /// Trims the current array of milestones removing all milestones with a date that was prior to the "today" value
    /// specified.
    ///
    /// For all remaining milestones, set their `today` date to the specified value.
    ///
    /// - parameter today:    The value to simulate being the current date.
    /// - parameter calendar: The calendar system to use for calculating days before today.
    ///
    /// - returns: The trimmed set of milestones.
    func trimmingBefore(applyingToday today: Date, calendar: Calendar) -> [Milestone] {
        return compactMap { milestone -> Milestone? in
            if calendar.compare(milestone.date, to: today, toGranularity: .day) == .orderedAscending {
                return nil
            }

            var offsetMilestone = milestone
            offsetMilestone.today = today
            return offsetMilestone
        }
    }
}
