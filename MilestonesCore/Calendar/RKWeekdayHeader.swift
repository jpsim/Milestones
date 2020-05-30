import SwiftUI

struct CalendarHeader: View {
    let calendar: Calendar

    var body: some View {
        HStack(alignment: .center) {
            ForEach(getWeekdayHeaders(calendar: calendar), id: \.self) { weekday in
                Text(weekday)
                    .font(.system(size: 20))
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }

    func getWeekdayHeaders(calendar: Calendar) -> [String] {
        let formatter = DateFormatter()

        var weekdaySymbols = formatter.shortStandaloneWeekdaySymbols
        let weekdaySymbolsCount = weekdaySymbols?.count ?? 0

        for _ in 0 ..< (1 - calendar.firstWeekday + weekdaySymbolsCount) {
            let lastObject = weekdaySymbols?.last
            weekdaySymbols?.removeLast()
            weekdaySymbols?.insert(lastObject!, at: 0)
        }

        return weekdaySymbols ?? []
    }
}
