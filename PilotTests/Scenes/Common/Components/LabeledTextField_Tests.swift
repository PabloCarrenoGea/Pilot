import XCTest
@testable import Pilot

final class LabeledTextField_Tests: XCTestCase {
    private var sut: LabeledTextField!

    override func setUpWithError() throws {
        sut = LabeledTextField()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // setViewData for LabeledTestField type .textField
    func testSetViewDataTextfield() {
        // Given
        let viewData = LabeledTextFieldViewData(label: "test", isSecureEntry: true, type: .textField)
        
        // When
        sut.setViewData(viewData)
        
        // Then
        XCTAssertTrue(sut.textField.isUserInteractionEnabled, "TestError: LabeledTestField should .textField type")
    }
    
    // setViewData for LabeledTestField type .picker
    func testSetViewDataPicker() {
        // Given
        let viewData = LabeledTextFieldViewData(label: "test",
                                                isSecureEntry: true,
                                                type: .picker(elements: [], default: "", associatedVc: UIViewController()))
        
        // When
        sut.setViewData(viewData)
        
        // Then
        XCTAssertFalse(sut.textField.isUserInteractionEnabled, "TestError: LabeledTestField should .picker type")
    }
    
    // test that the updateValidator func updates correctly the validators array with the validater argument
    func testUpdateValidator() {
        // Given
        sut.validators = [LengthValidator(length: 5), CharacterValidator(characterSet: .lowercaseLetters)]
        
        // When
        let validatorLength = LengthValidator(length: 3)
        sut.updateValidator(validatorLength)
        
        // Then
        XCTAssertTrue(sut.validators[1].isValid("aaa"), "TestError: validator not updated correctly")
    }
}
