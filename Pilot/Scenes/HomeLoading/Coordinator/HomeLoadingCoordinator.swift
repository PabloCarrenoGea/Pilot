import UIKit

final class HomeLoadingCoordinator: Coordinator {

    private let external: HomeLoadingExternalDependencies
    private lazy var dependencies = Dependency(external: external, coordinator: self)
    private var childCoordinatos: [Coordinator] = []

    init(external: HomeLoadingExternalDependencies) {
        self.external = external
    }

    var onFinish: (() -> Void)?

    func start() {
        let navigationController: UINavigationController? = dependencies.external.resolve()
        navigationController?.pushViewController(dependencies.resolve(), animated: true)
    }

    func goToConfirmation() {
        let coordinator = dependencies.external.confirmationCoordinator()
        coordinator.start()
        appendCoordinator(coordinator)
    }

    func goToRegistration() {
        let coordinator = dependencies.external.registrationCoordinator()
        coordinator.start()
        appendCoordinator(coordinator)
    }
}

private extension HomeLoadingCoordinator {
    struct Dependency: HomeLoadingDependencies {
        var external: HomeLoadingExternalDependencies
        unowned let coordinator: HomeLoadingCoordinator

        func resolve() -> HomeLoadingCoordinator {
            coordinator
        }
    }

    func appendCoordinator(_ coordinator: Coordinator) {
        childCoordinatos.append(coordinator)
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self, let coordinator else { return }
            self.childCoordinatos.removeCoordinator(coordinator)
        }
    }
}
