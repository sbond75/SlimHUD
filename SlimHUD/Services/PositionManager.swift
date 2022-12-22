//
//  PositionManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation
import Cocoa

class PositionManager {
    var volumeHud: Hud
    var brightnessHud: Hud
    var keyboardHud: Hud
    let settingsManager = SettingsManager.getInstance()

    init(volumeHud: Hud, brightnessHud: Hud, keyboardHud: Hud) {
        self.volumeHud = volumeHud
        self.brightnessHud = brightnessHud
        self.keyboardHud = keyboardHud
    }

    func setupHUDsPosition(_ isFullscreen: Bool) {
        volumeHud.hide(animated: false)
        brightnessHud.hide(animated: false)
        keyboardHud.hide(animated: false)

        let barViewFrame = volumeHud.view.frame

        let screenFrame = DisplayManager.getScreenFrame()
        var visibleFrame = DisplayManager.getVisibleScreenFrame()
        var xDockHeight: CGFloat = 0
        var yDockHeight: CGFloat = 0

        if !isFullscreen {
            visibleFrame = DisplayManager.getVisibleScreenFrame()
            (xDockHeight, yDockHeight) = DisplayManager.getDockHeight()
        }

        let originPosition = PositionManager.calculateHUDsOriginPosition(hudPosition: settingsManager.position,
                                                                         dockPosition: DisplayManager.getDockPosition(),
                                                                         xDockHeight: xDockHeight,
                                                                         yDockHeight: yDockHeight,
                                                                         visibleFrame: visibleFrame,
                                                                         hudSize: barViewFrame,
                                                                         screenFrame: screenFrame,
                                                                         isInFullscreen: isFullscreen)

        setHudsPosition(originPosition: originPosition)

        let isHudHorizontal = settingsManager.position == .bottom || settingsManager.position == .top

        // set bar views orientation
        setBarsOrientation(isHorizontal: isHudHorizontal)

        // set icons rotation
        if settingsManager.shouldShowIcons {
            setIconsRotation(isHorizontal: isHudHorizontal)
        }

        NSLog("screenFrame is \(screenFrame) \(originPosition)")
    }

    // todo write tests
    static func calculateHUDsOriginPosition(hudPosition: Position, dockPosition: Position,
                                            xDockHeight: CGFloat, yDockHeight: CGFloat,
                                            visibleFrame: NSRect, hudSize: NSRect, screenFrame: NSRect,
                                            isInFullscreen: Bool) -> CGPoint {
        var position: CGPoint
        switch hudPosition {
        case .left:
            position = CGPoint(x: dockPosition == .right ? 0 : xDockHeight,
                               y: (visibleFrame.height/2) - (hudSize.height/2) + yDockHeight)
        case .right:
            position = CGPoint(x: screenFrame.width - hudSize.width - Constants.ShadowRadius - (dockPosition == .left ? 0 : xDockHeight),
                               y: (visibleFrame.height/2) - (hudSize.height/2)  + yDockHeight)
        case .bottom:
            position = CGPoint(x: (screenFrame.width/2) - (hudSize.height/2),
                               y: yDockHeight)
        case .top:
            position = CGPoint(x: (screenFrame.width/2) - (hudSize.height/2),
                               y: screenFrame.height - hudSize.width - Constants.ShadowRadius - (isInFullscreen ? 0 : DisplayManager.getMenuBarThickness()))
        }
        return position
    }

    private func setHudsPosition(originPosition: CGPoint) {
        setHudPosition(hud: volumeHud, originPosition: originPosition)
        setHudPosition(hud: brightnessHud, originPosition: originPosition)
        setHudPosition(hud: keyboardHud, originPosition: originPosition)
    }
    private func setHudPosition(hud: Hud, originPosition: CGPoint) {
        hud.originPosition = originPosition
        hud.screenEdge = settingsManager.position
    }

    private func setBarsOrientation(isHorizontal: Bool) {
        setBarOrientation(barView: volumeHud.view, isHorizontal: isHorizontal)
        setBarOrientation(barView: brightnessHud.view, isHorizontal: isHorizontal)
        setBarOrientation(barView: keyboardHud.view, isHorizontal: isHorizontal)
    }
    private func setBarOrientation(barView: NSView, isHorizontal: Bool) {
        let barViewFrame = barView.frame
        barView.layer?.anchorPoint = CGPoint(x: 0, y: 0)
        if isHorizontal {
            barView.frameCenterRotation = -90
            barView.setFrameOrigin(.init(x: 0, y: barViewFrame.width))
        } else {
            barView.frameCenterRotation = 0
            barView.setFrameOrigin(.init(x: 0, y: 0))
        }

        // needs a bit more space for displaying shadows...
        if settingsManager.position == .right {
            barView.setFrameOrigin(.init(x: Constants.ShadowRadius, y: 0))
        }
        if settingsManager.position == .top {
            barView.setFrameOrigin(.init(x: 0, y: Constants.ShadowRadius + barViewFrame.width))
        }
    }

    private func setIconsRotation(isHorizontal: Bool) {
        if let volumeView = volumeHud.view as? BarView {
            setIconRotation(icon: volumeView.image, isHorizontal: isHorizontal)
        }
    }

    private func setIconRotation(icon: NSImageView, isHorizontal: Bool) {
        if isHorizontal {
            while icon.boundsRotation.truncatingRemainder(dividingBy: 360) != 90 {
                icon.rotate(byDegrees: 90)
            }
        } else {
            while icon.boundsRotation.truncatingRemainder(dividingBy: 360) != 0 {
                icon.rotate(byDegrees: 90)
            }
        }
    }
}