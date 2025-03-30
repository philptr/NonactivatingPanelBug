//
//  AppDelegate.swift
//  NonactivatingPanelBugDemo
//
//  Created by Phil Zakharchenko on 2/11/25.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: NSPanel!
    var panelStatusLabel: NSTextField!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        panel = Panel(contentRect: .init(x: 0, y: 0, width: 600, height: 400), styleMask: Panel.nonactivatingStyleMask, backing: .buffered, defer: false)
        
        let contentView = NSView()
        panelStatusLabel = NSTextField(labelWithString: "")
        let textField = NSTextField(string: "Try clicking and typing here")
        
        let button = NSButton(title: "Toggle Nonactivating Panel Bit", target: self, action: #selector(didClickButton(_:)))
        
        let stackView = NSStackView(views: [
            panelStatusLabel,
            button,
            textField,
        ])
        
        stackView.orientation = .vertical
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        contentView.addConstraints([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        updatePanelStatusLabel()
        panel.contentView = contentView
        
        panel.makeKey()
        panel.orderFrontRegardless()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @objc
    private func didClickButton(_ sender: NSButton) {
        if panel.styleMask.contains(.nonactivatingPanel) {
            panel.styleMask = Panel.regularStyleMask
        } else {
            panel.styleMask = Panel.nonactivatingStyleMask
        }
        
        updatePanelStatusLabel()
    }
    
    private func updatePanelStatusLabel() {
        if panel.styleMask.contains(.nonactivatingPanel) {
            panelStatusLabel.stringValue = "Panel is currently nonactivating"
        } else {
            panelStatusLabel.stringValue = "Panel is currently regular / not nonactivating"
        }
    }
}

final class Panel: NSPanel {
    static let nonactivatingStyleMask: NSWindow.StyleMask = [.nonactivatingPanel, .borderless, .resizable]
    static let regularStyleMask: NSWindow.StyleMask = [.closable, .resizable, .titled]
    
    override var canBecomeKey: Bool { true }
}
