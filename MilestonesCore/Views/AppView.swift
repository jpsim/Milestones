import ComposableArchitecture
import SwiftUI

// MARK: - View

public struct AppView: View {
    let store: Store<AppState, AppAction>

    public func sceneDidDisconnect() {
        ViewStore(store).send(.persistToDisk)
    }

    public func performAddQuickAction() {
        ViewStore(store).send(.addButtonTapped)
    }

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
                .onAppear {
                    viewStore.send(.setTimerActive(true))
                }
                .onDisappear {
                    viewStore.send(.setTimerActive(false))
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
