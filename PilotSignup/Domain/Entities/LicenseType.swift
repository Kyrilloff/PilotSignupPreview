//
//  LicenseType.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Foundation

/// License type is part of the pilot license
struct LicenseType: Codable, Equatable, Hashable, Identifiable {
    let id: UUID
    let name: String
    
    init(id: UUID = UUID(),
         name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: LicenseType, rhs: LicenseType) -> Bool {
        return lhs.name == rhs.name
    }
}
