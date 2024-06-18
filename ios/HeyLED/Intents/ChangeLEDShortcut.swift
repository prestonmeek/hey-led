//
//  ChangeLEDShortcut.swift
//  HeyLED
//
//  Created by Preston Meek on 6/17/24.
//

import Foundation
import AppIntents

struct BreakLoggerShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
              intent: LogBreakIntent(),
              phrases: [
                "Set my LEDs to \(\.$color)",
                "Set my LEDs to \(\.$color) with \(.applicationName)",
              ],
              shortTitle: "Complete Task",
              systemImageName: "checkmark"
        )
    }
}
