import ComposableArchitecture
@testable import MilestonesCore
import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

class SnapshotTests: XCTestCase {
    func testCalendarView() {
        let view = CalendarView(
            calendar: Calendar(identifier: .gregorian),
            startDate: Date(timeIntervalSince1970: 60 * 60 * 24 * 8),
            endDate: Date(timeIntervalSince1970: 60 * 60 * 24 * 32)
        )

        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)), named: "light-mode")
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), named: "dark-mode")
    }

    func testAppView() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSince1970: 0),
            date: Date(timeIntervalSince1970: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = Store(
            initialState: AppState(milestones: [milestone]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in fatalError()},
                startOfDay: { Date(timeIntervalSince1970: 0) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: DispatchQueue.testScheduler.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue.testScheduler.eraseToAnyScheduler()
            )
        )
        let view = AppView(store: store)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)), named: "light-mode")
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), named: "dark-mode")
    }

    func testAppViewEditing() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSince1970: 0),
            date: Date(timeIntervalSince1970: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = Store(
            initialState: AppState(milestones: [milestone], editMode: .active),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in fatalError()},
                startOfDay: { Date(timeIntervalSince1970: 0) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: DispatchQueue.testScheduler.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue.testScheduler.eraseToAnyScheduler()
            )
        )
        let view = AppView(store: store)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)), named: "light-mode")
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), named: "dark-mode")
    }

    func testTodayView() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSince1970: 0),
            date: Date(timeIntervalSince1970: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = Store(
            initialState: AppState(milestones: [milestone]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in fatalError()},
                startOfDay: { Date(timeIntervalSince1970: 0) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: DispatchQueue.testScheduler.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue.testScheduler.eraseToAnyScheduler()
            )
        )
        let view = TodayView(store: store)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)), named: "light-mode")
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), named: "dark-mode")
    }

    func testMilestoneEditView() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: Calendar(identifier: .gregorian),
            title: "Big Day",
            today: Date(timeIntervalSince1970: 0),
            date: Date(timeIntervalSince1970: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = Store(
            initialState: milestone,
            reducer: milestoneReducer,
            environment: MilestoneEnvironment()
        )
        let view = MilestoneEditView(store: store)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)), named: "light-mode")
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), named: "dark-mode")
    }
}
