import ComposableArchitecture
@testable import MilestonesCore
import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

class SnapshotTests: XCTestCase {
    func testRawData() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        assertSnapshot(matching: calendar, as: .dump)
        let date = Date(timeIntervalSince1970: 60 * 60 * 24 * 7)
        let dateFormatter = DateFormatter(calendar: calendar, dateStyle: .long)
        XCTAssertEqual(dateFormatter.string(from: date), "January 7, 1970")
    }
}
