import Combine

enum RegistrationViewModelState {
    case buttonEnabled(isEnabled: Bool)
    case licensesReceived(licenses: [String])
}

// MARK: - ViewModel

final class RegistrationViewModel {

    // MARK: Properties
    
    private var isNameValid = false
    private var isLicenseValid = false
    private var isPasswordValid = false
    private var passwordMatches = false

    private var name = ""
    private var license = ""

    private var dependencies: RegistrationDependencies

    private var stateSubject = PassthroughSubject<RegistrationViewModelState, Never>()
    var state: AnyPublisher<RegistrationViewModelState, Never> { stateSubject.eraseToAnyPublisher() }

    init(dependencies: RegistrationDependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: Public Methods

    func viewDidLoad() {
        licensesUseCase.execute { licenses in
            stateSubject.send(.licensesReceived(licenses: licenses.pilotLicenses.map { $0.type }))
        }
    }

    func updateName(_ name: String, isValid: Bool) {
        self.name = name
        isNameValid = isValid
        updateSaveEnabled()
    }

    func updateLicense(_ license: String, isValid: Bool) {
        self.license = license
        isLicenseValid = isValid
        updateSaveEnabled()
    }

    func updatePassword(_ password: String, isValid: Bool) {
        isPasswordValid = isValid
        updateSaveEnabled()
    }

    func updatePasswordMatching(_ matches: Bool) {
        passwordMatches = matches
        updateSaveEnabled()
    }

    func didTapRegister() {
        persistUseCase
            .execute(data: PersistedUser(name: name, license: license),
                     onSuccess: {
                coordinator.goToConfirmation()
            },
                     onError: { error in
                print(error)
            })
    }
}

// MARK: Private Methods

private extension RegistrationViewModel {
    var licensesUseCase: RetrieveLicensesUseCase { dependencies.resolve() }
    var persistUseCase: PersistUserUseCase { dependencies.resolve() }
    var coordinator: RegistrationCoordinator { dependencies.resolve() }

    func updateSaveEnabled() {
        stateSubject.send(.buttonEnabled(isEnabled: (isNameValid
                                                     && isLicenseValid
                                                     && isPasswordValid
                                                     && passwordMatches)))
    }
}
