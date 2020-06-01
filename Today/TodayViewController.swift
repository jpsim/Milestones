import MilestonesCore
import NotificationCenter
import UIKit
import SwiftUI

class TodayViewController: UIViewController, NCWidgetProviding {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = maxSize
    }

    @IBSegueAction func embed(_ coder: NSCoder) -> UIViewController? {
        let host = UIHostingController(coder: coder, rootView: TodayView.live)
        host?.view.backgroundColor = .clear
        return host
    }
}
