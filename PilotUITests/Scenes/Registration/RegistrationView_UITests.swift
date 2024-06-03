import XCTest

final class RegistrationView_UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Checks as you write the mandatory conditions for the passwords the errors dissapear
    func testName() {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When
        let secureTextField = app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .secureTextField).element
        secureTextField.tap()
        app.typeText("!")
        // Then
        XCTAssert(app.staticTexts["Must be 12 characters length or longer"].exists)
        XCTAssert(app.staticTexts["Must contain at least one lowercased character"].exists)
        XCTAssert(app.staticTexts["Must contain at least one uppercased character"].exists)
        XCTAssert(app.staticTexts["Must contain at least one decimal character"].exists)
        
        // When
        app.typeText("aaaaaaaa")
        // Then
        XCTAssert(app.staticTexts["Must be 12 characters length or longer"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one lowercased character"].exists)
        XCTAssert(app.staticTexts["Must contain at least one uppercased character"].exists)
        XCTAssert(app.staticTexts["Must contain at least one decimal character"].exists)
        
        // When
        app.typeText("Q")
        // Then
        XCTAssert(app.staticTexts["Must be 12 characters length or longer"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one lowercased character"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one uppercased character"].exists)
        XCTAssert(app.staticTexts["Must contain at least one decimal character"].exists)
        
        // When
        app.typeText("1")
        // Then
        XCTAssert(app.staticTexts["Must be 12 characters length or longer"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one lowercased character"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one uppercased character"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one decimal character"].exists)
        
        // When
        app.typeText("1")
        // Then
        XCTAssertFalse(app.staticTexts["Must be 12 characters length or longer"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one lowercased character"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one uppercased character"].exists)
        XCTAssertFalse(app.staticTexts["Must contain at least one decimal character"].exists)
    }
    
    func testPicker() {
        // Given
        let app = XCUIApplication()
        app.launch()
        
        // When
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["go down"].tap()
        elementsQuery.buttons["PPL"].tap()
               
        // Then
        XCTAssert(app.textFields["PPL"].exists, "Textfield license picker should show PPL license choosed")
    }
}
