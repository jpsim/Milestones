import MilestonesCore
import SwiftUI
import UIKit

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var appView = AppView.live

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = (scene as? UIWindowScene).map(UIWindow.init)
        window?.rootViewController = UIHostingController(rootView: appView)
        window?.makeKeyAndVisible()

        if connectionOptions.shortcutItem != nil {
            appView.performAddQuickAction()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        appView.sceneDidDisconnect()
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        appView.performAddQuickAction()
    }
}

// MARK: - AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
