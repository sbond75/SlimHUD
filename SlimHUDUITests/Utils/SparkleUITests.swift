//
//  SparkleUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 23/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

class SparkleUITests: UITestsUtils {
    static var TIMEOUT = 10

    static public func closeAlerts(app: XCUIApplication) -> Bool {
        var closedSomeDialogs = false
        while app.dialogs.count > 0 {
            app.dialogs.firstMatch.buttons.firstMatch.doubleClick()
            closedSomeDialogs = true
        }
        return closedSomeDialogs
    }

    static public func waitForAlertAndClose(app: XCUIApplication, timeout: Int) {
        var timeoutCountdown = timeout
        while !SparkleUITests.closeAlerts(app: app) && timeoutCountdown > 0 {
            sleep(1)
            timeoutCountdown -= 1
        }
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
}