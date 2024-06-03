import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var childCoordinators: [Coordinator] = []

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        let appDependencies = AppDependencies(navigationController: navigationController)
        window?.rootViewController = navigationController
        let initialCoordinator = appDependencies.homeLoadingCoordinator()
        initialCoordinator.start()
        childCoordinators.append(initialCoordinator)
        window?.makeKeyAndVisible()
    }
}

