import ComposableArchitecture
import SwiftUI
import UIKit

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let calendar = Calendar.current
        let appView = AppView(
            store: Store(
                initialState: AppState(
                    milestones: (try? Storage.loadFromDisk()) ?? []
                ),
                reducer: appReducer,
                environment: AppEnvironment(
                    uuid: UUID.init,
                    persist: { try? Storage.persist(dates: $0) },
                    startOfDay: { calendar.startOfDay(for: Date()) },
                    calendar: calendar,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )

        window = (scene as? UIWindowScene).map(UIWindow.init)
        window?.rootViewController = UIHostingController(rootView: appView)
        window?.makeKeyAndVisible()
    }
}

// MARK: - AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
