import Foundation
@testable import MilestonesCore
import XCTest

class MilestonesTrimmingTests: XCTestCase {
    func testYesterday() {
        let milestoneYesterday = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: .testCalendar,
            title: "Yesterday",
            today: Date(timeIntervalSinceReferenceDate: 123),
            date: Date(timeIntervalSinceReferenceDate: 0),
            isEditing: false
        )

        XCTAssertEqual(
            [milestoneYesterday].trimmingBefore(
                applyingToday: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24),
                calendar: .testCalendar
            ),
            []
        )
    }

    func testEarlierToday() {
        let milestoneEarlierToday = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: .testCalendar,
            title: "Earlier Today",
            today: Date(timeIntervalSinceReferenceDate: 123),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24),
            isEditing: false
        )

        XCTAssertEqual(
            [milestoneEarlierToday].trimmingBefore(
                applyingToday: Date(timeIntervalSinceReferenceDate: (60 * 60 * 24) + 123),
                calendar: .testCalendar
            ),
            [milestoneEarlierToday.with(today: Date(timeIntervalSinceReferenceDate: (60 * 60 * 24) + 123))]
        )
    }

    func testLaterToday() {
        let milestoneLaterToday = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: .testCalendar,
            title: "Later Today",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: (60 * 60 * 24) + 456),
            isEditing: false
        )

        XCTAssertEqual(
            [milestoneLaterToday].trimmingBefore(
                applyingToday: Date(timeIntervalSinceReferenceDate: (60 * 60 * 24) + 123),
                calendar: .testCalendar
            ),
            [milestoneLaterToday.with(today: Date(timeIntervalSinceReferenceDate: (60 * 60 * 24) + 123))]
        )
    }

    func testTomorrow() {
        let milestoneTomorrow = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: .testCalendar,
            title: "Tomorrow",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 2),
            isEditing: false
        )

        XCTAssertEqual(
            [milestoneTomorrow].trimmingBefore(
                applyingToday: Date(timeIntervalSinceReferenceDate: (60 * 60 * 24) + 123),
                calendar: .testCalendar
            ),
            [milestoneTomorrow.with(today: Date(timeIntervalSinceReferenceDate: (60 * 60 * 24) + 123))]
        )
    }
}

private extension Milestone {
    func with(today: Date) -> Milestone {
        var copy = self
        copy.today = today
        return copy
    }
}

private extension Calendar {
    static var testCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }
}
