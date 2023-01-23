//
//  ShadowedBox.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

@IBDesignable
class CustomView: NSView {
    @IBInspectable var shadowColor: NSColor = .black
    
    @IBInspectable var backgroundColor: NSColor = .white
    
    @IBInspectable var shadowed: Bool = true
    
    override func awakeFromNib() {
        setupShadow(shadowed, 2)
        layer?.shadowColor = shadowColor.cgColor
        layer?.backgroundColor = backgroundColor.cgColor
    }
}
