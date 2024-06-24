//
//  ChangeLEDIntent.swift
//  HeyLED
//
//  Created by Preston Meek on 6/17/24.
//

import AppIntents
import SwiftUI

// TODO: https://github.com/SwiftyAlex/Samples/blob/main/wwdc22/macchiato/macchiato/Model/Coffee.swift

struct ColorEntity: AppEntity {
    var id: UUID
    var name: String
    
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

extension ColorEntity {
    private static let colors = [
        "Red", "Orange", "Yellow", "Green", "Blue", "Purple"
    ]
    
    static let all = colors.map {
        ColorEntity(name: $0)
    }
}

struct ColorQuery: EntityStringQuery {
    func entities(for ids: [UUID]) async throws -> [ColorEntity] {
        ColorEntity.all.filter { ids.contains($0.id) }
    }
    
    func entities(matching name: String) async throws -> [ColorEntity] {
        return ColorEntity.all.filter { $0.name.contains(name) }
    }
    
    public func suggestedEntities() async throws -> [ColorEntity] {
        ColorEntity.all
    }
}

struct ChangeLEDIntent: AppIntent {
    static let title: LocalizedStringResource = "Set LEDs"
    
    @Parameter(title: "Color")
    var color: ColorEntity

    func perform() async throws -> some IntentResult & ProvidesDialog {
        // mqtt5.publish(msg: color.name.lowercased())

        return .result(dialog: "Set LEDs to \(color.name.lowercased())")
    }
}
