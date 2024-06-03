import UIKit

protocol RegistrationDependencies {
    var external: RegistrationExternalDependencies { get }
    func resolve() -> RegistrationViewController
    func resolve() -> RegistrationViewModel
    func resolve() -> RegistrationCoordinator
    func resolve() -> RetrieveLicensesUseCase
    func resolve() -> PersistUserUseCase
}

protocol RegistrationExternalDependencies {
    func resolve() -> UINavigationController?
    func registrationCoordinator() -> Coordinator
}

extension RegistrationExternalDependencies {
    func registrationCoordinator() -> Coordinator {
        RegistrationCoordinator(external: self)
    }
}

extension RegistrationDependencies {
    func resolve() -> RegistrationViewController {
        RegistrationViewController(dependencies: self)
    }

    func resolve() -> RegistrationViewModel {
        RegistrationViewModel(dependencies: self)
    }

    func resolve() -> RetrieveLicensesUseCase {
        DefaultRetrieveLicensesUseCase()
    }

    func resolve() -> PersistUserUseCase {
        DefaultPersistUserUseCase()
    }
}
