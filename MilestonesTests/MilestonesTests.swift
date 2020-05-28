import ComposableArchitecture
@testable import Milestones
import XCTest

class MilestoneReducerTests: XCTestCase {
    func testSetIsEditing() throws {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            calendar: Calendar(identifier: .gregorian),
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
}
