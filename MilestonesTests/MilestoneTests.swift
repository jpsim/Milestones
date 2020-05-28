@testable import Milestones
import XCTest

class MilestoneTests: XCTestCase {
    func testComparableDate() {
        let milestoneA = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "A",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let milestoneB = Milestone(
            id: UUID(uuidString: "CAFEBEEF-CAFE-BEEF-CAFE-BEEFCAFEBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "B",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 0),
            isEditing: false
        )

        XCTAssertLessThan(milestoneB, milestoneA)
    }

    func testComparableTitle() {
        let milestoneA = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "A",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let milestoneB = Milestone(
            id: UUID(uuidString: "CAFEBEEF-CAFE-BEEF-CAFE-BEEFCAFEBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "B",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        XCTAssertLessThan(milestoneA, milestoneB)
    }
}
