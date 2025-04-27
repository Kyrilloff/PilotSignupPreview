//
//  Aircraft.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Foundation

/// Aircraft is part of the pilot license - it tells which Aircraft the license holder is allowed to operate
struct Aircraft: Codable, Equatable, Hashable, Identifiable {
    let id: UUID
    let name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Aircraft, rhs: Aircraft) -> Bool {
        return lhs.name == rhs.name
    }
}
