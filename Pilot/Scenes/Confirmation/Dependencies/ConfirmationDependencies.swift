import UIKit

protocol ConfirmationExternalDependencies {
    func resolve() -> UINavigationController?
    func confirmationCoordinator() -> Coordinator
}

extension ConfirmationExternalDependencies {
    func confirmationCoordinator() -> Coordinator {
        ConfirmationCoordinator(external: self)
    }
}

protocol ConfirmationDependencies {
    var external: ConfirmationExternalDependencies { get }
    func resolve() -> ConfirmationViewController
    func resolve() -> ConfirmationViewModel
    func resolve() -> ConfirmationCoordinator
    func resolve() -> FetchStoredUserWithAirecraftsUseCase
    func resolve() -> RemovePersistedUserUseCase
}

extension ConfirmationDependencies {
    func resolve() -> ConfirmationViewController {
        ConfirmationViewController(dependencies: self)
    }

    func resolve() -> ConfirmationViewModel {
        ConfirmationViewModel(dependencies: self)
    }

    func resolve() -> FetchStoredUserWithAirecraftsUseCase {
        DefaultFetchStoredUserWithAirecraftsUseCase()
    }

    func resolve() -> RemovePersistedUserUseCase {
        DefaultRemovePersistedUserUseCase()
    }
}

