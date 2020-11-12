import ComposableArchitecture
import Foundation
import WidgetKit

public extension AppView {
    static var live: AppView {
        return AppView(
            store: Store(
                initialState: .fromDiskIfPossible(),
                reducer: appReducer,
                environment: .live
            )
        )
    }
}

public extension MilestonesWidgetView {
    static func live(startingDate: Date) -> MilestonesWidgetView {
        let storedMilestones = (try? Storage.loadFromDisk()) ?? []
        let milestonesOffsetByStartingDate = storedMilestones.compactMap { milestone -> Milestone? in
            let dateComparison = Calendar.current.compare(milestone.date, to: startingDate, toGranularity: .day)
            if dateComparison == .orderedAscending {
                return nil
            }

            var offsetMilestone = milestone
            offsetMilestone.today = startingDate
            return offsetMilestone
        }
        return MilestonesWidgetView(milestones: milestonesOffsetByStartingDate)
    }
}

private extension AppState {
    static func fromDiskIfPossible() -> AppState {
        return AppState(milestones: (try? Storage.loadFromDisk()) ?? [])
    }
}

private extension AppEnvironment {
    static var live: AppEnvironment {
        return AppEnvironment(
            uuid: UUID.init,
            persist: { dates in
                try? Storage.persist(dates: dates)
                WidgetCenter.shared.reloadAllTimelines()
            },
            startOfDay: { Calendar.current.startOfDay(for: Date()) },
            calendar: Calendar.current,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            persistenceQueue: DispatchQueue(label: "com.jpsim.Milestones.persistence", qos: .userInteractive)
                .eraseToAnyScheduler()
        )
    }
}
