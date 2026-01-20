//
//  LossyArray.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import Foundation

struct LossyArray<Element: Codable>: Codable {
    let elements: [Element]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var result: [Element] = []

        while !container.isAtEnd {
            do {
                let element = try container.decode(Element.self)
                result.append(element)
            } catch {
                // ⚠️ Skip invalid element
                print("⚠️ Skipping invalid element:", error)

                // Advance the container to avoid infinite loop
                _ = try? container.decode(EmptyDecodable.self)
            }
        }

        self.elements = result
    }
}

struct EmptyDecodable: Decodable {}
