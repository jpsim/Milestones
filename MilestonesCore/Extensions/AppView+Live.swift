import ComposableArchitecture
import Foundation

extension AppView {
    public static var live: AppView {
        return AppView(store: {
            let calendar = Calendar.current
            return Store(
                initialState: AppState(
                    milestones: (try? Storage.loadFromDisk()) ?? []
                ),
                reducer: appReducer,
                environment: AppEnvironment(
                    uuid: UUID.init,
                    persist: { try? Storage.persist(dates: $0) },
                    startOfDay: { calendar.startOfDay(for: Date()) },
                    calendar: calendar,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    persistenceQueue: DispatchQueue(label: "com.jpsim.Milestones.persistence", qos: .userInteractive)
                        .eraseToAnyScheduler()
                )
            )
        }())
    }
}
