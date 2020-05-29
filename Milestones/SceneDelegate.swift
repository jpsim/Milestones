import ComposableArchitecture
import SwiftUI
import UIKit

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var store: Store<AppState, AppAction> = {
        let calendar = Calendar.current
        return Store(
            initialState: AppState(
                milestones: (try? Storage.loadFromDisk()) ?? []
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: UUID.init,
                persist: { try? Storage.persist(dates: $0) },
                startOfDay: { calendar.startOfDay(for: Date()) },
                calendar: calendar,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                persistenceQueue: DispatchQueue(label: "com.jpsim.Milestones.persistence", qos: .userInteractive)
                    .eraseToAnyScheduler()
            )
        )
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = (scene as? UIWindowScene).map(UIWindow.init)
        window?.rootViewController = UIHostingController(rootView: AppView(store: store))
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        ViewStore(store).send(.persistToDisk)
    }
}

// MARK: - AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
