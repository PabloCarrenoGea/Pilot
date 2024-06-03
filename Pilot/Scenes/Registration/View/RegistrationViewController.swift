import UIKit
import Combine

// MARK: - ViewController

final class RegistrationViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var nameLTF: LabeledTextField!
    @IBOutlet weak var pilotLicenseLTF: LabeledTextField!
    @IBOutlet private weak var passwordLTF: LabeledTextField!
    @IBOutlet private weak var confirmPasswordLTF: LabeledTextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private let viewModel: RegistrationViewModel
    private var subscriptions = Set<AnyCancellable>()

    init(dependencies: RegistrationDependencies) {
        viewModel = dependencies.resolve()
        super.init(nibName: "RegistrationViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel.viewDidLoad()
    }
}

// MARK: - Private Methods

private extension RegistrationViewController {
    func setupViews() {
        title = "Registration"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesBackButton = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutside)))
        nameLTF.setViewData(LabeledTextFieldViewData(label: "Name"))
        nameLTF.validators = [NameValidator()]
        pilotLicenseLTF.setViewData(LabeledTextFieldViewData(label: "License type", type: .picker(elements: [], default: "Choose one", associatedVc: self)))
        passwordLTF.setViewData(LabeledTextFieldViewData(label: "Password", isSecureEntry: true))
        passwordLTF.validators = [LengthValidator(length: 12),
                                  CharacterValidator(characterSet: .lowercaseLetters),
                                  CharacterValidator(characterSet: .uppercaseLetters),
                                  CharacterValidator(characterSet: .decimalDigits),
                                  TextMatchingValidator(matchText: nameLTF.textField.text ?? "", shouldMatch: false, errorMessage: "Password cannot contain username")]
        confirmPasswordLTF.setViewData(LabeledTextFieldViewData(label: "Confirm password", isSecureEntry: true))
    }
    
    // MARK: - Binds

    func bind() {
        nameLTF.state
            .sink { [weak self] state in
                switch state {
                case .valid(let value):
                    self?.viewModel.updateName(value, isValid: true)
                    self?.passwordLTF.updateValidator(TextMatchingValidator(matchText: value, shouldMatch: false, errorMessage: "Cannot contain username"))
                case .error:
                    self?.viewModel.updateName("", isValid: false)
                }
            }
            .store(in: &subscriptions)
        pilotLicenseLTF.state
            .sink { [weak self] state in
                guard case .valid(let value) = state else {
                    return
                }
                self?.viewModel.updateLicense(value, isValid: true)
            }
            .store(in: &subscriptions)
        passwordLTF.state
            .sink { [weak self] state in
                switch state {
                case .valid(let value):
                    self?.viewModel.updatePassword(value, isValid: true)
                    self?.confirmPasswordLTF.updateValidator(TextMatchingValidator(matchText: value, shouldMatch: true, errorMessage: "Password doesn't match"))
                case .error:
                    self?.viewModel.updatePassword("", isValid: false)
                }
            }
            .store(in: &subscriptions)
        confirmPasswordLTF.state
            .sink { [weak self] state in
                switch state {
                case .valid:
                    self?.viewModel.updatePasswordMatching(true)
                case .error:
                    self?.viewModel.updatePasswordMatching(false)
                }
            }
            .store(in: &subscriptions)
        viewModel.state
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .buttonEnabled(let isEnabled):
                    self.saveButton.isEnabled = isEnabled
                case .licensesReceived(let licenses):
                    self.pilotLicenseLTF.setViewData(LabeledTextFieldViewData(label: "License type", type: .picker(elements: licenses, default: "Choose one", associatedVc: self)))
                }
            }
            .store(in: &subscriptions)
    }

    // MARK: - IBActions
    
    @IBAction func didTapSave(_ sender: UIButton) {
        viewModel.didTapRegister()
    }

    @objc func didTapOutside() {
        view.endEditing(true)
    }
}
