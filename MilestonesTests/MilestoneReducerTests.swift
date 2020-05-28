import ComposableArchitecture
@testable import Milestones
import XCTest

class MilestoneReducerTests: XCTestCase {
    func testSetIsEditing() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = TestStore(initialState: milestone, reducer: milestoneReducer, environment: MilestoneEnvironment())

        store.assert(.send(.setIsEditing(true)) {
            $0.isEditing = true
        })

        store.assert(.send(.setIsEditing(false)) {
            $0.isEditing = false
        })
    }

    func testDelete() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = TestStore(initialState: milestone, reducer: milestoneReducer, environment: MilestoneEnvironment())
        store.assert(.send(.delete) { _ in })
    }

    func testSetTitle() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = TestStore(initialState: milestone, reducer: milestoneReducer, environment: MilestoneEnvironment())

        store.assert(.send(.setTitle("Birthday")) {
            $0.title = "Birthday"
        })
    }

    func testSetDate() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = TestStore(initialState: milestone, reducer: milestoneReducer, environment: MilestoneEnvironment())

        store.assert(.send(.setDate(Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 31))) {
            $0.date = Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 31)
        })
    }
}
