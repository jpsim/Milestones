import ComposableArchitecture
@testable import MilestonesCore
import SnapshotTesting
import SwiftUI
import UIKit
import XCTest

class SnapshotTests: XCTestCase {
    func testDateFormatter() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = Date(timeIntervalSince1970: 60 * 60 * 24 * 7)
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateStyle = .long
        XCTAssertEqual(dateFormatter.string(from: date), "January 7, 1970")
    }

    func test_dateStyleLong() {

        let timestamps = [
            -31536000 : "January 1, 1969 at 12:00:00 AM GMT" , 0.0 : "January 1, 1970 at 12:00:00 AM GMT", 31536000 : "January 1, 1971 at 12:00:00 AM GMT",
            2145916800 : "January 1, 2038 at 12:00:00 AM GMT", 1456272000 : "February 24, 2016 at 12:00:00 AM GMT", 1456358399 : "February 24, 2016 at 11:59:59 PM GMT",
            1452574638 : "January 12, 2016 at 4:57:18 AM GMT", 1455685038 : "February 17, 2016 at 4:57:18 AM GMT", 1458622638 : "March 22, 2016 at 4:57:18 AM GMT",
            1459745838 : "April 4, 2016 at 4:57:18 AM GMT", 1462597038 : "May 7, 2016 at 4:57:18 AM GMT", 1465534638 : "June 10, 2016 at 4:57:18 AM GMT",
            1469854638 : "July 30, 2016 at 4:57:18 AM GMT", 1470718638 : "August 9, 2016 at 4:57:18 AM GMT", 1473915438 : "September 15, 2016 at 4:57:18 AM GMT",
            1477285038 : "October 24, 2016 at 4:57:18 AM GMT", 1478062638 : "November 2, 2016 at 4:57:18 AM GMT", 1482641838 : "December 25, 2016 at 4:57:18 AM GMT"
        ]

        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .long
        f.timeZone = TimeZone(identifier: "GMT")
        f.locale = Locale(identifier: "en_US_POSIX")

        for (timestamp, stringResult) in timestamps {

            let testDate = Date(timeIntervalSince1970: timestamp)
            let sf = f.string(from: testDate)

            XCTAssertEqual(sf, stringResult)
        }

    }
}
