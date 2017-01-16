//
//  KeyboardCalculatorUITests.swift
//  KeyboardCalculatorUITests
//
//  Created by Tricia Rudloff on 1/10/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import XCTest

class KeyboardCalculatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test1() {
        let app = XCUIApplication()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["2"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["8"].exists)
    }
    
    func test2() {
        let app = XCUIApplication()
        app.buttons["6"].tap()
        app.buttons["-"].tap()
        app.buttons["2"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["4"].exists)
    }
    
    func test3() {
        let app = XCUIApplication()
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["+"].tap()
        XCTAssert(app.staticTexts["6"].exists)
    }
    
    func test4() {
        let app = XCUIApplication()
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        XCTAssert(app.staticTexts["27"].exists)
    }
    
    func test5() {
        let app = XCUIApplication()
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["x"].tap()
        XCTAssert(app.staticTexts["24"].exists)
    }
    
    func test6() {
        let app = XCUIApplication()
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["x"].tap()
        app.buttons["+"].tap()
        XCTAssert(app.staticTexts["27"].exists)
    }
    
    func test7() {
        let app = XCUIApplication()
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["x"].tap()
        XCTAssert(app.staticTexts["27"].exists)
    }
    
    //2+4*/
    func test8() {
        let app = XCUIApplication()
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["÷"].tap()
        XCTAssert(app.staticTexts["4"].exists)
    }
    //2+4*6+*
    func test9() {
        let app = XCUIApplication()
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["x"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["578"].exists)
    }
    
    func test10() {
        let app = XCUIApplication()
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["18"].exists)
    }
    
    func test11() {
        let app = XCUIApplication()
        app.buttons["2"].tap()
        app.buttons["x"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["64"].exists)
    }
    
    func test12() {
        let app = XCUIApplication()
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["10"].exists)
    }
    
    func test13() {
        let app = XCUIApplication()
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["162"].exists)
    }
    
    func test14() {
        let app = XCUIApplication()
        app.buttons["2"].tap()
        app.buttons["0"].tap()
        app.buttons["x"].tap()
        app.buttons["5"].tap()
        app.buttons["%"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["1"].exists)
    }
    
    func test15() {
        let app = XCUIApplication()
        app.buttons["2"].tap()
        app.buttons["0"].tap()
        app.buttons["+"].tap()
        app.buttons["5"].tap()
        app.buttons["%"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["21"].exists)
    }
    
    func test16() {
        let app = XCUIApplication()
        app.buttons["5"].tap()
        app.buttons["0"].tap()
        app.buttons["+"].tap()
        app.buttons["2"].tap()
        app.buttons["0"].tap()
        app.buttons["x"].tap()
        app.buttons["5"].tap()
        app.buttons["%"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["51"].exists)
    }
    
    func test17() {
        let app = XCUIApplication()
        app.buttons["8"].tap()
        app.buttons["%"].tap()
        app.buttons["0"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["inf"].exists)
    }
    
    func test18() {
        let app = XCUIApplication()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["+"].tap()
        app.buttons["-"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["30"].exists)
    }
    
    func test19() {
        let app = XCUIApplication()
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["x"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["27"].exists)
    }
    
}
