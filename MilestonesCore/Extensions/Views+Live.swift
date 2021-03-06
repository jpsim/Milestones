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
        return MilestonesWidgetView(
            milestones: (try? Storage.loadFromDisk()) ?? []
                .trimmingBefore(applyingToday: startingDate, calendar: .current)
        )
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
