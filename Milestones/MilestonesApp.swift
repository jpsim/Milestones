import MilestonesCore
import SwiftUI

private let quickActionToPerform = QuickActionToPerform()

// MARK: - App

@main
struct MilestonesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @SceneBuilder var body: some Scene {
        WindowGroup {
            AppView.live
                .environmentObject(quickActionToPerform)
        }
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        quickActionToPerform.quickAction = options.shortcutItem != nil ? .add : nil
        let sceneConfiguration = UISceneConfiguration(name: "Scene Configuration",
                                                      sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void)
    {
        quickActionToPerform.quickAction = .add
    }
}
