import Foundation

protocol Validator {
    func isValid(_ text: String) -> Bool
    var errorMessage: String { get }
}

struct NameValidator: Validator {
    let errorMessage = "Profile name should contain at least one character which is not whitespace"

    func isValid(_ text: String) -> Bool {
        text.contains(where: { !$0.isWhitespace })
    }
}

struct LengthValidator: Validator {

    var errorMessage: String { "Must be \(length) characters length or longer" }
    private let length: Int

    init(length: Int) {
        self.length = length
    }

    func isValid(_ text: String) -> Bool {
        text.count >= length
    }
}

struct CharacterValidator: Validator {
    var errorMessage: String { "Must contain at least one \(description) character" }

    private var characterSet: CharacterSet

    init(characterSet: CharacterSet) {
        self.characterSet = characterSet
    }

    private var description: String {
        switch characterSet {
        case .uppercaseLetters: return "uppercased"
        case .lowercaseLetters: return "lowercased"
        case .decimalDigits: return "decimal"
        default: fatalError("Provide a description for character set: \(characterSet)")
        }
    }

    func isValid(_ text: String) -> Bool {
        return text.contains {
            switch characterSet {
            case .uppercaseLetters: $0.isUppercase
            case .lowercaseLetters: $0.isLowercase
            case .decimalDigits: $0.isNumber
            default: true
            }
        }
    }
}

struct TextMatchingValidator: Validator {
    var matchText: String
    let shouldMatch: Bool
    let errorMessage: String

    init(matchText: String, shouldMatch: Bool, errorMessage: String) {
        self.matchText = matchText
        self.shouldMatch = shouldMatch
        self.errorMessage = errorMessage
    }

    func isValid(_ text: String) -> Bool {
        shouldMatch ? text == matchText : !text.contains(matchText)
    }
}
