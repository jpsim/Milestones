import ComposableArchitecture
import SwiftUI
import WidgetKit

public struct MilestonesWidgetView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    let milestones: [Milestone]

    private var truncatedMilestones: ArraySlice<Milestone> {
        milestones.prefix(widgetFamily.maxMilestoneCount)
    }

    public var body: some View {
        if milestones.isEmpty {
            Text("No upcoming milestones")
        } else {
            VStack {
                ForEach(truncatedMilestones) { milestone in
                    MilestoneBaseCellView(store:
                        Store(
                            initialState: milestone,
                            reducer: .empty,
                            environment: MilestoneEnvironment()
                        ),
                        size: widgetFamily.cellSize
                    )
                    .padding(widgetFamily.padding)

                    if milestone != truncatedMilestones.last {
                        Divider()
                    }
                }
            }
        }
    }
}

private extension WidgetFamily {
    var maxMilestoneCount: Int {
        switch self {
        case .systemSmall:
            return 1
        case .systemMedium:
            return 2
        case .systemLarge:
            fallthrough
        @unknown default:
            return 4
        }
    }

    var padding: CGFloat {
        switch self {
        case .systemSmall:
            return 8.0
        case .systemMedium, .systemLarge:
            fallthrough
        @unknown default:
            return 0
        }
    }

    var cellSize: MilestoneBaseCellView.Size {
        switch self {
        case .systemSmall:
            return .normal
        case .systemMedium, .systemLarge:
            fallthrough
        @unknown default:
            return .compact
        }
    }
}
