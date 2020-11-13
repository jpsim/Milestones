import ComposableArchitecture
@testable import MilestonesCore
import SwiftUI
import XCTest

// swiftlint:disable type_body_length - We should probably break up the main appReducer

class AppReducerTests: XCTestCase {
    let mainScheduler = DispatchQueue.testScheduler
    let persistenceScheduler = DispatchQueue.testScheduler

    func testEditMode() {
        let store = TestStore(
            initialState: AppState(milestones: []),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in fatalError() },
                startOfDay: { fatalError() },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: mainScheduler.eraseToAnyScheduler(),
                persistenceQueue: persistenceScheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.editModeChanged(.active)) { $0.editMode = .active },
            .send(.editModeChanged(.inactive)) { $0.editMode = .inactive }
        )
    }

    func testEditModeDelete() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        var persistedValues = [[Milestone]]()

        let store = TestStore(
            initialState: AppState(milestones: [milestone]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { persistedValues.append($0) },
                startOfDay: { fatalError() },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: mainScheduler.eraseToAnyScheduler(),
                persistenceQueue: persistenceScheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.delete([0])) {
                $0.milestones = []
            },
            .send(.persistToDisk)
        )

        XCTAssertEqual(persistedValues, [[]])
    }

    func testTimer() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        var secondsElapsed: TimeInterval = 0

        let store = TestStore(
            initialState: AppState(milestones: [milestone]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in },
                startOfDay: { Date(timeIntervalSinceReferenceDate: secondsElapsed) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: mainScheduler.eraseToAnyScheduler(),
                persistenceQueue: persistenceScheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.setTimerActive(true)) { _ in },
            .do {
                secondsElapsed += 1
                self.mainScheduler.advance(by: 1)
            },
            .receive(.timerTicked) {
                $0.milestones = [
                    Milestone(
                        id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
                        calendar: Calendar(identifier: .gregorian),
                        title: "Big Day",
                        today: Date(timeIntervalSinceReferenceDate: 1),
                        date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                        isEditing: false
                    )
                ]
            },
            .send(.setTimerActive(false)) { _ in },
            .send(.persistToDisk)
        )
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

        var persistedValues = [[Milestone]]()

        let store = TestStore(
            initialState: AppState(milestones: [milestone]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { persistedValues.append($0) },
                startOfDay: { fatalError() },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: mainScheduler.eraseToAnyScheduler(),
                persistenceQueue: persistenceScheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.milestone(index: 0, action: .delete)) {
                $0.milestones = []
            },
            .send(.persistToDisk)
        )

        XCTAssertEqual(persistedValues, [[]])
    }

    func testAddButtonTapped() {
        var persistedValues = [[Milestone]]()

        let store = TestStore(
            initialState: AppState(milestones: []),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")! },
                persist: { persistedValues.append($0) },
                startOfDay: { Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: mainScheduler.eraseToAnyScheduler(),
                persistenceQueue: persistenceScheduler.eraseToAnyScheduler()
            )
        )

        let expectedMilestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "",
            today: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: true
        )

        store.assert(
            .send(.addButtonTapped) {
                $0.milestones = [expectedMilestone]
            },
            .send(.persistToDisk)
        )

        XCTAssertEqual(persistedValues, [[expectedMilestone]])
    }

    func testSort() {
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

        var persistedValues = [[Milestone]]()

        let store = TestStore(
            initialState: AppState(milestones: [milestoneA, milestoneB]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { persistedValues.append($0) },
                startOfDay: { fatalError() },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: mainScheduler.eraseToAnyScheduler(),
                persistenceQueue: persistenceScheduler.eraseToAnyScheduler()
            )
        )

        let expectedMilestones = [
            Milestone(
                id: UUID(uuidString: "CAFEBEEF-CAFE-BEEF-CAFE-BEEFCAFEBEEF")!,
                calendar: Calendar(identifier: .gregorian),
                title: "B",
                today: Date(timeIntervalSinceReferenceDate: 0),
                date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                isEditing: false
            ),
            Milestone(
                id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
                calendar: Calendar(identifier: .gregorian),
                title: "C",
                today: Date(timeIntervalSinceReferenceDate: 0),
                date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                isEditing: false
            )
        ]

        store.assert(
            .send(.milestone(index: 0, action: .setTitle("C"))) {
                $0.milestones = expectedMilestones
            },
            .send(.persistToDisk)
        )

        XCTAssertEqual(persistedValues, [expectedMilestones])
    }

    func testDebouncedPersistence() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "A",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        var persistedValues = [[Milestone]]()

        let store = TestStore(
            initialState: AppState(milestones: [milestone]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { persistedValues.append($0) },
                startOfDay: { fatalError() },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: mainScheduler.eraseToAnyScheduler(),
                persistenceQueue: persistenceScheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.milestone(index: 0, action: .setTitle("B"))) {
                $0.milestones = [
                    Milestone(
                        id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
                        calendar: Calendar(identifier: .gregorian),
                        title: "B",
                        today: Date(timeIntervalSinceReferenceDate: 0),
                        date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                        isEditing: false
                    )
                ]
            },
            .do {
                self.persistenceScheduler.advance(by: 0.9)
            },
            .send(.milestone(index: 0, action: .setTitle("C"))) {
                $0.milestones = [
                    Milestone(
                        id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
                        calendar: Calendar(identifier: .gregorian),
                        title: "C",
                        today: Date(timeIntervalSinceReferenceDate: 0),
                        date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                        isEditing: false
                    )
                ]
            },
            .do {
                self.persistenceScheduler.advance(by: 1)
            }
        )

        XCTAssertEqual(persistedValues, [[
            Milestone(
                id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
                calendar: Calendar(identifier: .gregorian),
                title: "C",
                today: Date(timeIntervalSinceReferenceDate: 0),
                date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                isEditing: false
            )
        ]])
    }

    func testAddButtonTappedClearsEditing() {
        let milestoneA = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "A",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: true
        )

        let store = TestStore(
            initialState: AppState(milestones: [milestoneA]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { UUID(uuidString: "CAFEBEEF-CAFE-BEEF-CAFE-BEEFCAFEBEEF")! },
                persist: { _ in },
                startOfDay: { Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: mainScheduler.eraseToAnyScheduler(),
                persistenceQueue: persistenceScheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .send(.addButtonTapped) {
                $0.milestones = [
                    Milestone(
                        id: UUID(uuidString: "CAFEBEEF-CAFE-BEEF-CAFE-BEEFCAFEBEEF")!,
                        calendar: Calendar(identifier: .gregorian),
                        title: "",
                        today: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                        date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                        isEditing: true
                    ),
                    Milestone(
                        id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
                        calendar: Calendar(identifier: .gregorian),
                        title: "A",
                        today: Date(timeIntervalSinceReferenceDate: 0),
                        date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
                        isEditing: false
                    )
                ]
            },
            .send(.persistToDisk)
        )
    }
}
