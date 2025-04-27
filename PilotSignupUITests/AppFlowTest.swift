//
//  AppFlowTest.swift
//  PilotSignupUITests
//
//  Created by Konrad Schmid on 20.02.25.
//

import XCTest

final class AppFlowTest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        super.tearDown()
    }
    
    func testAppFlow() {
        // registration screen element references
        let firstNameTextField = app.textFields["firstNameTextField"]
        let lastNameTextField = app.textFields["lastNameTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let passwordRepeatTextField = app.secureTextFields["passwordRepeatTextField"]
        let licensePicker = app.buttons["licensePicker"]
        let registerButton = app.buttons["registerButton"]
        
        // check if registration screen elements exist
        XCTAssertTrue(firstNameTextField.exists)
        XCTAssertTrue(lastNameTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(passwordRepeatTextField.exists)
        XCTAssertTrue(licensePicker.exists)
        XCTAssertTrue(registerButton.exists)
        
        // fill in registration information
        firstNameTextField.tap()
        firstNameTextField.typeText("Phil")
        
        lastNameTextField.tap()
        lastNameTextField.typeText("Flieger")
        
        passwordTextField.tap()
        passwordTextField.typeText("ValidPassword123")
        
        passwordRepeatTextField.tap()
        passwordRepeatTextField.typeText("ValidPassword123")
        
        // scroll up until license picker is in sight
        while !licensePicker.isHittable {
            passwordTextField.swipeUp()
        }
        
        // select license and register
        licensePicker.tap()
        let licenseOption = app.buttons["MPL"]
        XCTAssertTrue(licenseOption.waitForExistence(timeout: 1))
        licenseOption.tap()
        
        registerButton.tap()
        
        // check if logout button exists (= confirmation screen is shown) and log out
        let logoutButton = app.buttons["logoutButton"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 4))
        logoutButton.tap()
        
        // check if registration screen was dismissed
        XCTAssertFalse(registerButton.exists)
        
        // confirm logout in alert
        let logoutConfirmButton = app.buttons["logoutConfirmButton"]
        XCTAssertTrue(logoutConfirmButton.waitForExistence(timeout: 2))
        logoutConfirmButton.tap()
        
        // check if register button is showing again (= registration screen is shown)
        XCTAssertTrue(registerButton.waitForExistence(timeout: 1))
    }
}
