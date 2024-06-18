//
//  ChangeLEDIntent.swift
//  HeyLED
//
//  Created by Preston Meek on 6/17/24.
//

import AppIntents
import SwiftUI

// TODO: https://github.com/SwiftyAlex/Samples/blob/main/wwdc22/macchiato/macchiato/Model/Coffee.swift
let colorStore = [
    ColorEntity(name: "Red"),
    ColorEntity(name: "Blue"),
    ColorEntity(name: "Green")
]

struct ColorEntity: AppEntity {
    let id: UUID
    let name: String
    
    public init(name: String) {
        self.id = UUID.init()
        self.name = name
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(stringLiteral: "Color")
    var displayRepresentation: DisplayRepresentation {
        .init(stringLiteral: name)
    }
    
    typealias DefaultQueryType = ColorQuery
    static var defaultQuery: ColorQuery = ColorQuery()
}

struct ColorQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [ColorEntity] {
        colorStore.filter { string.lowercased().contains($0.name.lowercased()) }
    }
    
    func entities(for ids: [UUID]) async throws -> [ColorEntity] {
        colorStore.filter { ids.contains($0.id) }
    }
    
    public func suggestedEntities() async throws -> [ColorEntity] {
        colorStore
    }
}

struct LogBreakIntent: AppIntent {
    static let title: LocalizedStringResource = "Log a Break"
    
    @Parameter(title: "Color", description: "The color of the LEDs")
    var color: ColorEntity

    func perform() async throws -> some IntentResult & ProvidesDialog {
        mqtt5.publish(msg: color.name)

        return .result(dialog: "Set LEDs to \(color.name)")
    }
}

