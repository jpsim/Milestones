import SwiftUI

struct CalendarDateView: View {
    struct ViewState {
        let text: String
        let textColor: Color
        let textWeight: Font.Weight

        init(date: Date, calendar: Calendar, isDisabled: Bool) {
            let formatter = DateFormatter(calendar: calendar, dateFormat: "d")
            formatter.locale = .current
            self.text = formatter.string(from: date)
            self.textColor = isDisabled ? .gray : .primary
            self.textWeight = isDisabled ? .thin : .medium
        }
    }

    let state: ViewState

    var body: some View {
        Text(state.text)
            .fontWeight(state.textWeight)
            .foregroundColor(state.textColor)
            .font(.system(size: 20))
    }
}

struct CalendarDateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarDateView(state: .init(date: Date(), calendar: .current, isDisabled: true))
                .previewLayout(.sizeThatFits)
            CalendarDateView(state: .init(date: Date(), calendar: .current, isDisabled: false))
                .previewLayout(.sizeThatFits)
        }
    }
}
