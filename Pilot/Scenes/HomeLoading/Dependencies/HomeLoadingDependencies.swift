import UIKit

protocol HomeLoadingExternalDependencies {
    func resolve() -> UINavigationController?
    func homeLoadingCoordinator() -> Coordinator
    func registrationCoordinator() -> Coordinator
    func confirmationCoordinator() -> Coordinator
}

extension HomeLoadingExternalDependencies {
    func homeLoadingCoordinator() -> Coordinator {
        HomeLoadingCoordinator(external: self)
    }
}

protocol HomeLoadingDependencies {
    var external: HomeLoadingExternalDependencies { get }
    func resolve() -> HomeLoadingViewController
    func resolve() -> HomeLoadingViewModel
    func resolve() -> HomeLoadingCoordinator
    func resolve() -> CheckStoredUserUseCase
}

extension HomeLoadingDependencies {
    func resolve() -> HomeLoadingViewController {
        HomeLoadingViewController(dependencies: self)
    }

    func resolve() -> HomeLoadingViewModel {
        HomeLoadingViewModel(dependencies: self)
    }

    func resolve() -> CheckStoredUserUseCase {
        DefaultCheckStoredUserUseCase()
    }
}
