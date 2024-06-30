//
//  TurnLEDOffIntent.swift
//  Hey LED
//
//  Created by Preston Meek on 6/30/24.
//

import AppIntents
import SwiftUI

struct TurnLEDOffIntent: AppIntent {
    static let title: LocalizedStringResource = "Turn LEDs off"

    func perform() async throws -> some IntentResult & ProvidesDialog {
        mqtt5.publish(msg: "off")

        return .result(dialog: "Turned LEDs off")
    }
}
