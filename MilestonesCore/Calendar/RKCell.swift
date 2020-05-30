import SwiftUI

struct CalendarDateView: View {
    var rkDate: RKDate

    var cellWidth: CGFloat

    var body: some View {
        Text(rkDate.getText())
            .fontWeight(rkDate.getFontWeight())
            .foregroundColor(rkDate.getTextColor())
            .frame(width: cellWidth, height: cellWidth)
            .font(.system(size: 20))
    }
}
