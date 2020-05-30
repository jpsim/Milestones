import SwiftUI

struct CalendarHeaderView: View {
    let calendar: Calendar

    var weekdaySymbols: [String] {
        return DateFormatter(calendar: calendar).shortStandaloneWeekdaySymbols
    }

    var body: some View {
        HStack(alignment: .center) {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(.system(size: 20))
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView(calendar: .current)
            .previewLayout(.sizeThatFits)
    }
}
