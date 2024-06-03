import Foundation

// MARK: - ViewModel
final class HomeLoadingViewModel {
    
    // MARK: Properties
    
    private let dependencies: HomeLoadingDependencies
    
    init(dependencies: HomeLoadingDependencies) {
        self.dependencies = dependencies
    }

    // MARK: Public Methods
    
    func viewWillAppear() {
        checkStoredUseCase.execute { type in
            switch type {
            case .registration:
                coordinator.goToRegistration()
            case .confirmation:
                coordinator.goToConfirmation()
            }
        }
    }
}

// MARK: Private Methods

private extension HomeLoadingViewModel {
    var checkStoredUseCase: CheckStoredUserUseCase { dependencies.resolve() }
    var coordinator: HomeLoadingCoordinator { dependencies.resolve() }
}
