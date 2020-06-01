import ComposableArchitecture
import SwiftUI

// MARK: - View

struct MilestoneCellView: View {
    let store: Store<Milestone, MilestoneAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            MilestoneBaseCellView(store: self.store)
            .contextMenu {
                Button(action: { viewStore.send(.setIsEditing(true)) }) {
                    Text("Edit")
                    Image(systemName: "square.and.pencil")
                }

                Button(action: { viewStore.send(.delete) }) {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
            .popover(isPresented: viewStore.binding(get: \.isEditing, send: MilestoneAction.setIsEditing)) {
                MilestoneEditView(store: self.store)
            }
        }
    }
}

// MARK: - Previews

struct MilestoneCellView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            MilestoneCellView(store:
                Store(
                    initialState: Milestone(
                        id: UUID(),
                        calendar: .current,
                        title: "💍 Anniversary",
                        today: Date(),
                        date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 7),
                        isEditing: false
                    ),
                    reducer: milestoneReducer,
                    environment: MilestoneEnvironment()
                )
            )
            .previewLayout(.sizeThatFits)
            .environment(\.sizeCategory, sizeCategory)
            .previewDisplayName("\(sizeCategory)")
        }
    }
}
