import UIKit

final class ConfirmationCoordinator: Coordinator {

    private let external: ConfirmationExternalDependencies
    private lazy var dependencies = Dependency(coordinator: self, external: external)
    var onFinish: (() -> Void)?
    private var childCoordinators: [Coordinator] = []

    init(external: ConfirmationExternalDependencies) {
        self.external = external
    }
    
    func start() {
        let navigationController: UINavigationController? = dependencies.external.resolve()
        navigationController?.pushViewController(dependencies.resolve(), animated: true)
    }

    func doLogout() {
        let navigationController: UINavigationController? = dependencies.external.resolve()
        navigationController?.popViewController(animated: true)
        onFinish?()
    }
}

private extension ConfirmationCoordinator {
    struct Dependency: ConfirmationDependencies {
        unowned let coordinator: ConfirmationCoordinator
        var external: ConfirmationExternalDependencies

        func resolve() -> ConfirmationCoordinator {
            coordinator
        }
    }
}
