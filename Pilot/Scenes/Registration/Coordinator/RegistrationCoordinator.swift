import UIKit

final class RegistrationCoordinator: Coordinator {

    private let external: RegistrationExternalDependencies
    private lazy var dependencies = Dependency(external: external, coordinator: self)
    var onFinish: (() -> Void)?
    private var childCoordinators: [Coordinator] = []

    init(external: RegistrationExternalDependencies) {
        self.external = external
    }

    func start() {
        let navigationController: UINavigationController? = dependencies.external.resolve()
        navigationController?.pushViewController(dependencies.resolve(), animated: true)
    }

    func goToConfirmation() {
        let navigationController: UINavigationController? = dependencies.external.resolve()
        navigationController?.popToRootViewController(animated: true)
        onFinish?()
    }
}

private extension RegistrationCoordinator {
    struct Dependency: RegistrationDependencies {

        unowned let coordinator: RegistrationCoordinator
        let external: RegistrationExternalDependencies

        init(external: RegistrationExternalDependencies, coordinator: RegistrationCoordinator) {
            self.external = external
            self.coordinator = coordinator
        }

        func resolve() -> RegistrationCoordinator {
            coordinator
        }
    }
}
