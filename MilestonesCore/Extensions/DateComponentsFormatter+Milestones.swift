import Foundation

extension DateComponentsFormatter {
    convenience init(unitsStyle: DateComponentsFormatter.UnitsStyle) {
        self.init()
        self.unitsStyle = unitsStyle
    }
}
