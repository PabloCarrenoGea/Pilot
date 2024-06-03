import UIKit
import Combine

enum LabeledTextFieldState {
    case valid(value: String)
    case error
}

struct LabeledTextFieldViewData {
    let label: String
    let isSecureEntry: Bool
    let type: LabeledTextFieldType

    init(label: String, isSecureEntry: Bool = false, type: LabeledTextFieldType = .textField) {
        self.label = label
        self.isSecureEntry = isSecureEntry
        self.type = type
    }

    enum LabeledTextFieldType {
        case textField
        case picker(elements: [String], default: String, associatedVc: UIViewController)
    }
}

final class LabeledTextField: UIView {

    private var elements: [String] = []
    private weak var associatedVC: UIViewController?
    private var stateSubject = PassthroughSubject<LabeledTextFieldState, Never>()
    var state: AnyPublisher<LabeledTextFieldState, Never> { stateSubject.eraseToAnyPublisher() }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textFieldStackView)
        stackView.addArrangedSubview(errorMessagesStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(picker)
        picker.addTarget(self, action: #selector(didTapPicker), for: .touchUpInside)
        return stackView
    }()
    
    private lazy var picker: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 75).isActive = true
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapPicker), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.textContentType = .oneTimeCode
        textField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var errorMessagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    var validators: [Validator] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func setViewData(_ viewData: LabeledTextFieldViewData) {
        label.text = viewData.label
        textField.isSecureTextEntry = viewData.isSecureEntry
        guard case .picker(let elements, let defaultText, let associatedVC) = viewData.type else {
            return
        }
        picker.isHidden = false
        textField.isUserInteractionEnabled = false
        textField.text = defaultText
        self.elements = elements
        self.associatedVC = associatedVC
    }

    // updates the validator in the validaators array, and checks the validators of the textField
    func updateValidator<V: Validator>(_ validator: V) {
        validators.removeAll(where: { $0 is V })
        validators.append(validator)
        guard let text = textField.text, !text.isEmpty else { return }
        performValidationsWith(textField.text)
    }
    
    func createErrorMessageLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.text = text
        label.numberOfLines = 0
        label.textColor = .red
        label.isHidden = false
        return label
    }
}

private extension LabeledTextField {
    func commonInit() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // checks the text on this textField passes the validators associated with this textField
    func performValidationsWith(_ text: String?) {
        guard let text, !validators.isEmpty else { return }
        errorMessagesStackView.subviews.forEach({ $0.removeFromSuperview() }) // removes the errors from the previous text
        var passAllValidators = true
        validators.forEach { validator in   // checks the text for every validator for this textField
            if !validator.isValid(text) {   // if the validator returns that the text its not valid
                passAllValidators = false
                errorMessagesStackView.addArrangedSubview(  // // add the errorText of that validator to the errorStackView
                    createErrorMessageLabel(text: validator.errorMessage))
            }
        }
        if passAllValidators { // if all validators are valid hide the errorStackView
            errorMessagesStackView.isHidden = true
            stateSubject.send(.valid(value: text))
        } else { // if one or more validators are not valid shows the errorStackView
            errorMessagesStackView.isHidden = false
            stateSubject.send(.error)
        }
    }

    // listener that shows a picker with the license types
    @objc func didTapPicker() {
        guard let associatedVC = associatedVC else { return }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        elements.forEach { current in
            actionSheet.addAction(UIAlertAction(title: current, style: .default) { _ in
                self.textField.text = current
                self.stateSubject.send(.valid(value: current))
            })
        }
        // part to make it work properly on iPad
        if let actionSheet = actionSheet.popoverPresentationController {
            actionSheet.sourceView = associatedVC.view
            actionSheet.sourceRect = CGRect(x: associatedVC.view.bounds.midX, y: associatedVC.view.bounds.midY, width: 0, height: 0)
            actionSheet.permittedArrowDirections = []
        }
        associatedVC.present(actionSheet, animated: true)
    }
}

extension LabeledTextField: UITextFieldDelegate {
    
    // added delegate for UItest to be able to dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // when the text in the textFields change -> checks the validators
    @objc func textFieldDidChange(textfield: UITextField) {
        performValidationsWith(textField.text)
    }
}
