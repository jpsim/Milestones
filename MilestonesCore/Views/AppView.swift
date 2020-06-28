import ComposableArchitecture
import SwiftUI

// MARK: - View

public struct AppView: View {
    @EnvironmentObject private var quickActionToPerform: QuickActionToPerform
    @Environment(\.scenePhase) private var scenePhase
    let store: Store<AppState, AppAction>

    public var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.milestones,
                            action: AppAction.milestone
                        )
                    ) { milestoneStore in
                        WithViewStore(milestoneStore) { milestoneViewStore in
                            NavigationLink(
                                destination: CalendarView(
                                    calendar: milestoneViewStore.calendar,
                                    startDate: milestoneViewStore.today,
                                    endDate: milestoneViewStore.date
                                )
                                .navigationBarTitle(milestoneViewStore.title)
                            ) {
                                MilestoneCellView(store: milestoneStore)
                            }
                        }
                    }
                    .onDelete { viewStore.send(.delete($0)) }
                }
                .navigationBarTitle("Milestones")
                .navigationBarItems(
                    leading: viewStore.milestones.isEmpty ? nil : EditButton(),
                    trailing: Button("Add") {
                        viewStore.send(.addButtonTapped)
                    }
                )
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .active:
                        viewStore.send(.setTimerActive(true))
                        switch quickActionToPerform.quickAction {
                        case .add:
                            viewStore.send(.addButtonTapped)
                        case nil:
                            break
                        }
                    case .inactive, .background:
                        fallthrough
                    @unknown default:
                        viewStore.send(.setTimerActive(false))
                        viewStore.send(.persistToDisk)
                    }
                }
                .environment(
                  \.editMode,
                  viewStore.binding(get: { $0.editMode }, send: AppAction.editModeChanged)
                )
            }
        }
    }
}

// MARK: - Previews

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: Store(
            initialState: AppState(milestones: .mock),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: UUID.init,
                persist: { _ in },
                startOfDay: Date.init,
                calendar: .current,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        ))
    }
}
