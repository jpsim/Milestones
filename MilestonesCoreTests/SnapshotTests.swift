import ComposableArchitecture
@testable import MilestonesCore
import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

class SnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()
        diffTool = "ksdiff"
    }

    func testCalendarView() {
        let view = CalendarView(
            calendar: .testCalendar,
            startDate: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 8),
            endDate: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 32)
        )

        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .light), named: "light-mode")
        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .dark), named: "dark-mode")
    }

    func testAppView() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: .testCalendar,
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = Store(
            initialState: AppState(milestones: [milestone]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in fatalError()},
                startOfDay: { Date(timeIntervalSinceReferenceDate: 0) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: DispatchQueue.testScheduler.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue.testScheduler.eraseToAnyScheduler()
            )
        )
        let view = AppView(store: store)

        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .light), named: "light-mode")
        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .dark), named: "dark-mode")
    }

    func testAppViewEditingWithZeroMilestones() {
        let store = Store(
            initialState: AppState(milestones: [], editMode: .active),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in fatalError()},
                startOfDay: { Date(timeIntervalSinceReferenceDate: 0) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: DispatchQueue.testScheduler.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue.testScheduler.eraseToAnyScheduler()
            )
        )
        let view = AppView(store: store)

        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .light), named: "light-mode")
        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .dark), named: "dark-mode")
    }

    func testAppViewEditingWithOneMilestone() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: .testCalendar,
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = Store(
            initialState: AppState(milestones: [milestone], editMode: .active),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in fatalError()},
                startOfDay: { Date(timeIntervalSinceReferenceDate: 0) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: DispatchQueue.testScheduler.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue.testScheduler.eraseToAnyScheduler()
            )
        )
        let view = AppView(store: store)

        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .light), named: "light-mode")
        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .dark), named: "dark-mode")
    }

    func testTodayView() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: .testCalendar,
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: false
        )

        let store = Store(
            initialState: AppState(milestones: [milestone]),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError() },
                persist: { _ in fatalError()},
                startOfDay: { Date(timeIntervalSinceReferenceDate: 0) },
                calendar: Calendar(identifier: .gregorian),
                mainQueue: DispatchQueue.testScheduler.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue.testScheduler.eraseToAnyScheduler()
            )
        )
        let view = TodayView(store: store)

        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .light), named: "light-mode")
        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .dark), named: "dark-mode")
    }

    func testMilestoneEditView() {
        let milestone = Milestone(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            calendar: .testCalendar,
            title: "Big Day",
            today: Date(timeIntervalSinceReferenceDate: 0),
            date: Date(timeIntervalSinceReferenceDate: 60 * 60 * 24 * 7),
            isEditing: true
        )

        let store = Store(
            initialState: milestone,
            reducer: milestoneReducer,
            environment: MilestoneEnvironment()
        )
        let view = MilestoneEditView(store: store)

        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .light), named: "light-mode")
        assertSnapshot(matching: view, as: .iPhoneXsMaxImage(style: .dark), named: "dark-mode")
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

private extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    static func iPhoneXsMaxImage(style: UIUserInterfaceStyle) -> Snapshotting {
        return .image(layout: .device(config: .iPhoneXsMax), traits: .init(userInterfaceStyle: style))
    }
}
