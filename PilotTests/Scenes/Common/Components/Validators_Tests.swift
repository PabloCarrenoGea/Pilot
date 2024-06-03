import XCTest
@testable import Pilot

final class Validators_Tests: XCTestCase {

    // NameValidator: checks if the isValid function returns true for names without blanckSpaces, and false with blanckSpaces
    func testNameValidator() {
        // Given
        let nameValidator = NameValidator()
        
        // Then
        XCTAssertTrue(nameValidator.isValid("test"), "TestError: NameValidator.isValid should return true for names with at least one character which is not whitespace")
        XCTAssertFalse(nameValidator.isValid(" "), "TestError: NameValidator.isValid should return false for names with blankSpaces")
    }
    
    // LengthValidator: checks if the isValid function returns true for passwords with more than X length characters
    func testLengthValidator() {
        // Given
        let lengthValidator = LengthValidator(length: 3)
        
        // Then
        XCTAssertTrue(lengthValidator.isValid("test"), "TestError: LengthValidator.isValid should return true for passwords with more than X length characters")
        XCTAssertFalse(lengthValidator.isValid("te"), "TestError: LengthValidator.isValid should return false for passwords with more than X length characters")
    }
    
    // CharacterValidator: checks the if isValid function returns true for passwords with a uppercase character
    func testCharacterValidatorUppercase() {
        // Given
        let characterValidator = CharacterValidator(characterSet: .uppercaseLetters)
        
        // Then
        XCTAssertTrue(characterValidator.isValid("Test"), "TestError: characterValidator.isValid should return true for passwords with a uppercase character")
        XCTAssertFalse(characterValidator.isValid("test"), "TestError: characterValidator.isValid should return false for passwords with a uppercase character")
    }
    
    // CharacterValidator: checks if the isValid function returns true for passwords with a lowercase character
    func testCharacterValidatorLowercase() {
        // Given
        let characterValidator = CharacterValidator(characterSet: .lowercaseLetters)
        
        // Then
        XCTAssertTrue(characterValidator.isValid("Test"), "TestError: characterValidator.isValid should return true for passwords with a lowercase character")
        XCTAssertFalse(characterValidator.isValid("TEST"), "TestError: characterValidator.isValid should return false for passwords with a lowercase character")
    }
    
    // CharacterValidator: checks if the isValid function returns true for passwords with a decimal character
    func testCharacterValidatorDecimal() {
        // Given
        let characterValidator = CharacterValidator(characterSet: .decimalDigits)
        
        // Then
        XCTAssertTrue(characterValidator.isValid("Test3"), "TestError: characterValidator.isValid should return true for passwords with a decimal character")
        XCTAssertFalse(characterValidator.isValid("te"), "TestError: characterValidator.isValid should return false for passwords with a decimal character")
    }
    
    // TextMatchingValidator: checks matching texts
    func testTextMatchingValidatorMatching() {
        // Given
        let textMatchingValidator = TextMatchingValidator(matchText: "matchText", shouldMatch: true, errorMessage: "")
        
        // Then
        XCTAssertTrue(textMatchingValidator.isValid("matchText"), "TestError: characterValidator.isValid should return true when passwords match")
        XCTAssertFalse(textMatchingValidator.isValid("te"), "TestError: characterValidator.isValid should return false when passwords does not match")
    }
    
    // TextMatchingValidator: checks that texts does not match
    func testTextMatchingValidatorNotMatching() {
        // Given
        let textMatchingValidator = TextMatchingValidator(matchText: "matchText", shouldMatch: false, errorMessage: "")
        
        // Then
        XCTAssertTrue(textMatchingValidator.isValid("test"), "TestError: characterValidator.isValid should return true when passwords does not match")
        XCTAssertFalse(textMatchingValidator.isValid("matchText"), "TestError: characterValidator.isValid should return false when passwords match")
    }
}
