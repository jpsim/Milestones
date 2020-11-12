import MilestonesCore
import SwiftUI
import WidgetKit

private struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> MilestonesEntry {
        MilestonesEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context,
                     completion: @escaping (MilestonesEntry) -> Void)
    {
        completion(MilestonesEntry(date: Date(), configuration: configuration))
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context,
                     completion: @escaping (Timeline<Entry>) -> Void)
    {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        // Create an entry for the start of every day for the next 14 days
        let entries = (0..<14)
            .compactMap { Calendar.current.date(byAdding: .day, value: $0, to: startOfToday) }
            .map { date in
                MilestonesEntry(
                    date: date,
                    configuration: configuration
                )
            }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

private struct MilestonesEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

@main
struct MilestonesWidget: Widget {
    let kind: String = "MilestonesWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MilestonesWidgetView.live(startingDate: entry.date)
        }
        .configurationDisplayName("Milestones")
        .description("Counts down to upcoming milestones.")
    }
}
