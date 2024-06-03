//
//  ConfirmationView_UITests.swift
//  PilotUITests
//
//  Created by Anara Kokubayeva on 03/06/2024.
//

import XCTest

final class ConfirmationView_UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    // the test checks if we are log in, if then logout. Completes the registration fields and checks that the Confirmation scene is shown properly, then checks the logout proccess and checks we logout
    func testRegistrationProccessAndConfirmation() {
        let app = XCUIApplication()
        app.launch()
        
        let logOutButton = app.staticTexts["Logout"]
        if logOutButton.exists {
            logOutButton.tap()
        }
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.children(matching: .other).element(boundBy: 0)
        element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        app.typeText("Name")
        
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["go down"].tap()
        elementsQuery.buttons["PPL"].tap()
        app/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 1 page")/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\")",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .secureTextField).element.tap()
        element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .secureTextField).element.tap()
        
        var secureTextField = element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .secureTextField).element
        secureTextField.tap()
        app.typeText("aaaaaaaaaaQ1")
        
        secureTextField = element.children(matching: .other).element(boundBy: 3).children(matching: .other).element.children(matching: .other).element.children(matching: .secureTextField).element
        secureTextField.tap()
        app.typeText("aaaaaaaaaaQ1")
        secureTextField.typeText("\n")
        app/*@START_MENU_TOKEN@*/.staticTexts["Register"]/*[[".buttons[\"Register\"].staticTexts[\"Register\"]",".staticTexts[\"Register\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssert(app.staticTexts["Name"].exists)
        XCTAssert(app.staticTexts["PPL"].exists)
        XCTAssert(app.staticTexts["C152"].exists)
        XCTAssert(app.buttons["Logout"].exists)
        
        app.staticTexts["Logout"].tap()
        XCTAssert(app.staticTexts["Registration"].exists)
    }
}
