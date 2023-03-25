//
//  SettingsUITests.swift
//  SettingsUITests
//
//  Created by Alex Perathoner on 22/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class SettingsUITest: SparkleUITests {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testOpenSettingsWindow() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.windows.count == 0)

        app.activate()

        let settingsWindow = app.windows.matching(identifier: "SlimHUD").firstMatch
        XCTAssert(settingsWindow.waitForExistence(timeout: 5))
        addScreenshot(window: settingsWindow, name: "Settings")
    }

    func testCloseWindowWithCmdW() throws {
        let app = XCUIApplication()
        app.launch()
        app.activate()

        let settingsWindow = app.windows.matching(identifier: "SlimHUD").firstMatch

        settingsWindow.typeKey("w", modifierFlags: .command)
        usleep(10000)
        XCTAssertFalse(settingsWindow.isHittable)
    }

    func testCloseWindowWithCmdQ() throws {
        let app = XCUIApplication()
        app.launch()
        app.activate()

        let settingsWindow = app.windows.matching(identifier: "SlimHUD").firstMatch

        settingsWindow.typeKey("q", modifierFlags: .command)
        usleep(10000)
        app.dialogs["alert"].buttons["OK"].click()
        usleep(10000)
        XCTAssertFalse(settingsWindow.isHittable)
    }

    func testQuit() throws {
        let app = XCUIApplication()
        app.launch()
        app.activate()
        let settingsWindow = app.windows.matching(identifier: "SlimHUD").firstMatch
        settingsWindow.typeKey("q", modifierFlags: .command)
        usleep(10000)
        app.dialogs["alert"].buttons["Quit now"].click()
        usleep(10000)

        XCTAssertFalse(settingsWindow.isHittable)
        XCTAssertFalse(app.exists)
    }

    func testSwitchTabs() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.launch()

        let settingsWindow = XCUIApplication().windows["Settings"]

        settingsWindow.typeKey("4", modifierFlags: .command)
        XCTAssertTrue(settingsWindow.images["application icon"].waitForExistence(timeout: 1))

        settingsWindow.typeKey("1", modifierFlags: .command)
        XCTAssertTrue(settingsWindow.radioButtons["Top"].waitForExistence(timeout: 1))
    }

    func testChangePreviewHud() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.launch()

        let settingsWindow = app.windows["Settings"]
        settingsWindow.typeKey("2", modifierFlags: .command)

        let radioGroupsQuery = settingsWindow.radioGroups
        radioGroupsQuery.children(matching: .radioButton).element(boundBy: 0).click()
        XCTAssertEqual(settingsWindow.colorWells.count, 4)
        XCTAssertTrue(isVolumeHudVisible(app: app))

        radioGroupsQuery.children(matching: .radioButton).element(boundBy: 1).click()
        XCTAssertEqual(settingsWindow.colorWells.count, 3)
        XCTAssertTrue(isBrightnessHudVisible(app: app))

        radioGroupsQuery.children(matching: .radioButton).element(boundBy: 2).click()
        XCTAssertEqual(settingsWindow.colorWells.count, 3)
        XCTAssertTrue(isKeyboardHudVisible(app: app))
    }

    func testOpenShadowPopup() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.setShadowType(shadowType: "Standard")
        app.launch()

        let settingsWindow = XCUIApplication().windows["Settings"]
        settingsWindow.typeKey("3", modifierFlags: .command)

        settingsWindow.popUpButtons["Standard"].click()
        settingsWindow.menuItems["Custom..."].click()

        XCTAssertTrue(settingsWindow.popovers.count > 0)

        XCTAssertEqual(2, settingsWindow.popovers.children(matching: .slider).count)
        
    }
    
    func testChangeValuesInShadowPopupRadiusInput() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.setShadowType(shadowType: "Custom...")
        app.launch()
        let settingsWindow = XCUIApplication().windows["Settings"]
        settingsWindow.typeKey("3", modifierFlags: .command)
        settingsWindow.popUpButtons["Custom..."].click()
        settingsWindow.menuItems["Custom..."].click()
        
        let textFieldRadius = settingsWindow.popovers.children(matching: .textField).element(boundBy: 0)
        let sliderRadius = settingsWindow.popovers.children(matching: .slider).element(boundBy: 0)
        sliderRadius.adjust(toNormalizedSliderPosition: 0.5)
        sliderRadius.adjust(toNormalizedSliderPosition: 1.0)
        XCTAssertTrue("30" == textFieldRadius.value as? String || "29" == textFieldRadius.value as? String) // adjust(..) not able to drag to the very end of the slider
        sliderRadius.adjust(toNormalizedSliderPosition: 0.0)
        XCTAssertTrue("0" == textFieldRadius.value as? String || "1" == textFieldRadius.value as? String) // adjust(..) not able to drag to the very end of the slider
        textFieldRadius.typeText("30\r")
        XCTAssertEqual(1.0, sliderRadius.normalizedSliderPosition)
        textFieldRadius.typeText("0\r")
        XCTAssertEqual(0.0, sliderRadius.normalizedSliderPosition)
    }
    
    func testChangeValuesInShadowPopupInsetInput() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.setShadowType(shadowType: "Custom...")
        app.launch()
        let settingsWindow = XCUIApplication().windows["Settings"]
        settingsWindow.typeKey("3", modifierFlags: .command)
        settingsWindow.popUpButtons["Custom..."].click()
        settingsWindow.menuItems["Custom..."].click()
        
        
        let textFieldInset = settingsWindow.popovers.children(matching: .textField).element(boundBy: 1)
        let sliderInset = settingsWindow.popovers.children(matching: .slider).element(boundBy: 1)
        sliderInset.adjust(toNormalizedSliderPosition: 0.5)
        sliderInset.adjust(toNormalizedSliderPosition: 1.0)
        XCTAssertTrue("15" == textFieldInset.value as? String || "14" == textFieldInset.value as? String) // adjust(..) not able to drag to the very end of the slider
        sliderInset.adjust(toNormalizedSliderPosition: 0.0)
        XCTAssertTrue("-15" == textFieldInset.value as? String || "-14" == textFieldInset.value as? String) // adjust(..) not able to drag to the very end of the slider
        
        settingsWindow.popovers.children(matching: .textField).element(boundBy: 0).typeText("\t\t")
        
        textFieldInset.typeText("15\r")
        XCTAssertEqual(1.0, sliderInset.normalizedSliderPosition)
        textFieldInset.typeText("-15\r")
        XCTAssertEqual(0.0, sliderInset.normalizedSliderPosition)
    }
}
