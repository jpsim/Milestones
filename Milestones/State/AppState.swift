import ComposableArchitecture
import Foundation

// MARK: - State

struct AppState: Equatable {
    var milestones: [Milestone]

    mutating func setToday(_ today: Date) {
        milestones = milestones.map { milestone in
            var result = milestone
            result.today = today
            return result
        }
    }
}

// MARK: - Action

enum AppAction: Equatable {
    case setTimerActive(Bool)
    case timerTicked
    case addButtonTapped
    case milestone(index: Int, action: MilestoneAction)
}

// MARK: - Environment

struct AppEnvironment {
    let uuid: () -> UUID
    let persist: ([Milestone]) -> Void
    var startOfDay: () -> Date
    var calendar: Calendar
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var persistenceQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    milestoneReducer.forEach(
        state: \AppState.milestones,
        action: /AppAction.milestone,
        environment: { _ in MilestoneEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case .setTimerActive(let timerActive):
            state.setToday(environment.startOfDay())

            struct TimerID: Hashable {}

            return timerActive ?
                Effect.timer(id: TimerID(), every: 1, on: environment.mainQueue)
                .map { _ in .timerTicked }
                : Effect.cancel(id: TimerID())
        case .timerTicked:
            state.setToday(environment.startOfDay())
            return .none
        case .addButtonTapped:
            let startOfDay = environment.startOfDay()
            let calendar = environment.calendar
            state.milestones.append(
                Milestone(id: environment.uuid(), calendar: calendar, title: "", today: startOfDay, date: startOfDay,
                          isEditing: true)
            )
            state.milestones.sort()
            return .none
        case .milestone(index: let index, action: .delete):
            state.milestones.remove(at: index)
            return .none
        case .milestone:
            state.milestones.sort()
            return .none
        }
    }
)
.persisting()

// MARK: - Persistence

private struct PersistID: Hashable {}

private extension Reducer where State == AppState, Environment == AppEnvironment {
    /// Persists milestones when they change.
    func persisting() -> Reducer {
        return Reducer { state, action, environment in
            // Run the upstream app reducer like normal if milestones don't change.
            let previousState = state
            let effect = self(&state, action, environment)
            let newMilestones = state.milestones
            guard newMilestones != previousState.milestones else {
                return effect
            }

            // If milestones change, persist in a debounced fashion in the background.
            return .merge(
                effect,
                Effect.fireAndForget { environment.persist(newMilestones) }
                    .subscribe(on: environment.persistenceQueue)
                    .eraseToEffect()
                    .debounce(id: PersistID(), for: 1, scheduler: environment.persistenceQueue)
            )
        }
    }
}
