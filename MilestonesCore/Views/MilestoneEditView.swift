import ComposableArchitecture
import Introspect
import SwiftUI

// MARK: - View

struct MilestoneEditView: View {
    let store: Store<Milestone, MilestoneAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Spacer()

                    Button("Done") { viewStore.send(.setIsEditing(false)) }
                        .padding()
                }

                TextField(
                    "Title",
                    text: viewStore.binding(get: \.title, send: MilestoneAction.setTitle)
                )
                .introspectTextField { textField in
                    textField.becomeFirstResponder()
                }
                .font(.title)
                .padding()

                HStack {
                    Spacer()

                    DatePicker(
                        selection: viewStore.binding(get: \.date, send: MilestoneAction.setDate),
                        in: viewStore.today...,
                        displayedComponents: .date
                    ) {
                        EmptyView()
                    }
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                    .environment(\.timeZone, viewStore.calendar.timeZone)

                    Spacer()
                }

                Spacer()
            }
        }
    }
}

// MARK: - Previews

struct MilestoneEditView_Previews: PreviewProvider {
    static var previews: some View {
        MilestoneEditView(store:
            Store(
                initialState: Milestone(
                    id: UUID(),
                    calendar: .current,
                    title: "💍 Anniversary",
                    today: Date(),
                    date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 7),
                    isEditing: true
                ),
                reducer: milestoneReducer,
                environment: MilestoneEnvironment()
            )
        )
    }
}
