import ComposableArchitecture
import SwiftUI

// MARK: - View

struct MilestoneBaseCellView: View {
    struct ViewState: Equatable {
        let title: String?
        let subtitlePrefix: String
        let subtitleSuffix: String

        var isUntitled: Bool { title == nil }

        init(milestone: Milestone) {
            self.title = milestone.title.isEmpty ? nil : milestone.title

            let dateComponentsFormatter = DateComponentsFormatter(unitsStyle: .full)
            let components = milestone.calendar.dateComponents([.day], from: milestone.today, to: milestone.date)
            self.subtitlePrefix = dateComponentsFormatter.string(from: components)!

            let dateFormatter = DateFormatter(calendar: milestone.calendar, dateStyle: .long)
            self.subtitleSuffix = "until \(dateFormatter.string(from: milestone.date))"
        }
    }

    let store: Store<Milestone, MilestoneAction>

    var body: some View {
        WithViewStore(store.scope(state: ViewState.init)) { viewStore in
            VStack(alignment: .leading, spacing: 10.0) {
                Text(viewStore.title ?? "Untitled")
                    .font(.title)
                    .foregroundColor(viewStore.isUntitled ? .gray : nil)
                Text("\(Text(viewStore.subtitlePrefix).bold()) \(viewStore.subtitleSuffix)")
            }
        }
    }
}

// MARK: - Previews

struct MilestoneBaseCellView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            MilestoneBaseCellView(store:
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
