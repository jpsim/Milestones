import ComposableArchitecture
import SwiftUI

// MARK: - View

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
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
                }
                .navigationBarTitle("Milestones")
                .navigationBarItems(trailing: Button("Add") {
                    viewStore.send(.addButtonTapped)
                })
                .onAppear {
                    viewStore.send(.setTimerActive(true))
                }
                .onDisappear {
                    viewStore.send(.setTimerActive(false))
                }
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
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        ))
    }
}
