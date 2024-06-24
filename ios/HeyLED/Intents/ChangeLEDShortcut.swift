//
//  ChangeLEDShortcut.swift
//  HeyLED
//
//  Created by Preston Meek on 6/17/24.
//

import Foundation
import AppIntents

struct ChangeLEDShortcut: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
              intent: ChangeLEDIntent(),
              phrases: [
                "Use \(.applicationName)",
                "Use \(.applicationName) to set the color to \(\.$color)",
              ],
              shortTitle: "Set LEDs",
              systemImageName: "checkmark"
        )
    }
    
    init() {
        ChangeLEDShortcut.updateAppShortcutParameters()
    }
}
