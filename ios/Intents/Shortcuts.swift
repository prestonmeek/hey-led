//
//  ChangeLEDShortcut.swift
//  HeyLED
//
//  Created by Preston Meek on 6/17/24.
//

import Foundation
import AppIntents

struct Shortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
              intent: ChangeLEDIntent(),
              phrases: [
                "Use \(.applicationName)",
                "Turn on \(.applicationName)",
                "Use \(.applicationName) to set the color to \(\.$color)",
              ],
              shortTitle: "Change LEDs",
              systemImageName: "checkmark"
        );
        AppShortcut(
              intent: TurnLEDOffIntent(),
              phrases: [
                "Turn off \(.applicationName)",
                "Shut off \(.applicationName)",
                "Disable \(.applicationName)",
              ],
              shortTitle: "Turn LEDs off",
              systemImageName: "checkmark"
        )
    }
}
