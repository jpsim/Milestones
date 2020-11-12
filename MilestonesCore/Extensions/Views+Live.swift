import ComposableArchitecture
import Foundation

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

private extension AppState {
    static func fromDiskIfPossible() -> AppState {
        return AppState(milestones: (try? Storage.loadFromDisk()) ?? [])
    }
}

private extension AppEnvironment {
    static var live: AppEnvironment {
        return AppEnvironment(
            uuid: UUID.init,
            persist: { try? Storage.persist(dates: $0) },
            startOfDay: { Calendar.current.startOfDay(for: Date()) },
            calendar: Calendar.current,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            persistenceQueue: DispatchQueue(label: "com.jpsim.Milestones.persistence", qos: .userInteractive)
                .eraseToAnyScheduler()
        )
    }
}
