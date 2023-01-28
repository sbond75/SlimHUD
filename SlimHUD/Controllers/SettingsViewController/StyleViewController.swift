//
//  StyleViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 25/01/23.
//

import Cocoa

class StyleViewController: NSViewController {
    weak var delegate: HudsControllerInterface?
    var settingsManager = SettingsManager.getInstance()
    
    @IBOutlet weak var hudToEditOutlet: NSSegmentedControl!
    
    private func getSelectedHud() -> SelectedHud {
        do {
            return try hudToEditOutlet.getSelectedBar()
        } catch {
            fatalError("Multiple / No HUDs selected")
        }
    }
    
    @IBOutlet weak var barColorOutlet: NSColorWell!
    @IBOutlet weak var fillColorOutlet: NSColorWell!
    @IBOutlet weak var iconColorOutlet: NSColorWell!
    
    @IBOutlet weak var secondFillColorOutlet: NSColorWell!
    
    @IBOutlet weak var iconColorsContainerOutlet: NSView!
    
    override func viewDidLoad() {
        selectedHudClicked(self)
        if #unavailable(macOS 10.14) {
            iconColorsContainerOutlet.isHidden = true
        }
    }
    
    @IBAction func selectedHudClicked(_ sender: Any) {
        switch getSelectedHud() {
        case .volume:
            barColorOutlet.color = settingsManager.volumeBackgroundColor
            fillColorOutlet.color = settingsManager.volumeEnabledColor
            secondFillColorOutlet.color = settingsManager.volumeDisabledColor
            iconColorOutlet.color = settingsManager.volumeIconColor
            showSecondaryFillColorOutlet(true)
            break
        case .brightness:
            barColorOutlet.color = settingsManager.brightnessBackgroundColor
            fillColorOutlet.color = settingsManager.brightnessColor
            iconColorOutlet.color = settingsManager.brightnessIconColor
            showSecondaryFillColorOutlet(false)
            break
        case .keyboard:
            barColorOutlet.color = settingsManager.keyboardBackgroundColor
            fillColorOutlet.color = settingsManager.keyboardColor
            iconColorOutlet.color = settingsManager.keyboardIconColor
            showSecondaryFillColorOutlet(false)
            break
        }
    }
    
    private func showSecondaryFillColorOutlet(_ value: Bool) {
        var newFrame: NSRect = .init(x: 27, y: 77, width: 44, height: 28)
        if value {
            newFrame = .init(x: 27, y: 90, width: 44, height: 24)
        }
        fillColorOutlet.frame = newFrame
        secondFillColorOutlet.isHidden = !value
    }
    
    @IBAction func setBarColorClicked(_ sender: NSColorWell) {
        setBackgroundColor(hud: getSelectedHud(), color: sender.color)
    }
    @IBAction func setFillColorClicked(_ sender: NSColorWell) {
        setFillColor(hud: getSelectedHud(), color: sender.color)
    }
    @IBAction func setSecondaryFillColorClicked(_ sender: NSColorWell) {
        // secondary fill exists for volume hud only
        setVolumeDisabledColor(sender.color)
    }
    
    @IBAction func setIconColorClicked(_ sender: NSColorWell) {
        setIconColor(hud: getSelectedHud(), color: sender.color)
    }
    
    private func setBackgroundColor(hud: SelectedHud, color: NSColor) {
        switch hud {
        case .volume:
            setVolumeBackgroundColor(color)
            break
        case .brightness:
            setBrightnessBackgroundColor(color)
            break
        case .keyboard:
            setKeyboardBackgroundColor(color)
            break
        }
    }
    
    private func setFillColor(hud: SelectedHud, color: NSColor) {
        switch hud {
        case .volume:
            setVolumeEnabledColor(color)
            break
        case .brightness:
            setBrightnessColor(color)
            break
        case .keyboard:
            setKeyboardColor(color)
            break
        }
    }
    
    private func setIconColor(hud: SelectedHud, color: NSColor) {
        switch hud {
        case .volume:
            setVolumeIconColor(color)
            break
        case .brightness:
            setBrightnessIconColor(color)
            break
        case .keyboard:
            setKeyboardIconColor(color)
            break
        }
    }
    
    @IBAction func resetStyle(_ sender: Any) {
        switch getSelectedHud() {
        case .volume:
            setVolumeBackgroundColor(DefaultColors.DarkGray)
            setVolumeEnabledColor(DefaultColors.Blue)
            setVolumeIconColor(.white)
            break
        case .brightness:
            setBrightnessBackgroundColor(DefaultColors.DarkGray)
            setBrightnessIconColor(.white)
            setKeyboardColor(DefaultColors.Yellow)
            break
        case .keyboard:
            setKeyboardBackgroundColor(DefaultColors.DarkGray)
            setKeyboardIconColor(.white)
            setKeyboardColor(DefaultColors.Azure)
            break
        }
    }
    
}



extension StyleViewController {
    // MARK: volume HUD style methods
    private func setVolumeBackgroundColor(_ color: NSColor) {
        settingsManager.volumeBackgroundColor = color
        delegate?.setVolumeBackgroundColor(color: color)
    }
    private func setVolumeEnabledColor(_ color: NSColor) {
        settingsManager.volumeEnabledColor = color
        delegate?.setVolumeEnabledColor(color: color)
    }
    private func setVolumeDisabledColor(_ color: NSColor) {
        settingsManager.volumeDisabledColor = color
        delegate?.setVolumeDisabledColor(color: color)
    }
    private func setVolumeIconColor(_ color: NSColor) {
        settingsManager.volumeIconColor = color
        if #available(macOS 10.14, *) {
            delegate?.setVolumeIconsTint(color)
        }
    }
    
    // MARK: brightness HUD style methods
    private func setBrightnessBackgroundColor(_ color: NSColor) {
        settingsManager.brightnessBackgroundColor = color
        delegate?.setBrightnessBackgroundColor(color: color)
    }
    private func setBrightnessColor(_ color: NSColor) {
        settingsManager.brightnessColor = color
        delegate?.setBrightnessColor(color: color)
    }
    private func setBrightnessIconColor(_ color: NSColor) {
        settingsManager.brightnessIconColor = color
        if #available(macOS 10.14, *) {
            delegate?.setBrightnessIconsTint(color)
        }
    }
    
    // MARK: keyboard HUD style methods
    private func setKeyboardBackgroundColor(_ color: NSColor) {
        settingsManager.keyboardBackgroundColor = color
        delegate?.setKeyboardBackgroundColor(color: color)
    }
    private func setKeyboardColor(_ color: NSColor) {
        settingsManager.keyboardColor = color
        delegate?.setKeyboardColor(color: color)
    }
    private func setKeyboardIconColor(_ color: NSColor) {
        settingsManager.keyboardIconColor = color
        if #available(macOS 10.14, *) {
            delegate?.setKeyboardIconsTint(color)
        }
    }
}
