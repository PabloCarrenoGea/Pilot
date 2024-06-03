import Combine

enum ConfirmationViewModelState {
    case storedLoaded(ConfirmationOutput)
}

// MARK: - ViewModel

final class ConfirmationViewModel {
    
    // MARK: Properties
    
    private let dependencies: ConfirmationDependencies
    private var stateSubject = PassthroughSubject<ConfirmationViewModelState, Never>()

    var state: AnyPublisher<ConfirmationViewModelState, Never> { stateSubject.eraseToAnyPublisher() }

    init(dependencies: ConfirmationDependencies) {
        self.dependencies = dependencies
    }

    // MARK: Public Methods
    
    func viewDidLoad() {
        fetchStoredUseCase.execute(onSuccess: { output in
            stateSubject.send(.storedLoaded(output))
        },
                                   onError: { error in
            print(error ?? "")
        })
    }

    func didTapLogout() {
        removeUseCase.execute(onSuccess: {
            coordinator.doLogout()
        })
    }
}

// MARK: Private Methods

private extension ConfirmationViewModel {
    var fetchStoredUseCase: FetchStoredUserWithAirecraftsUseCase { dependencies.resolve() }
    var removeUseCase: RemovePersistedUserUseCase { dependencies.resolve() }
    var coordinator: ConfirmationCoordinator { dependencies.resolve() }
}
