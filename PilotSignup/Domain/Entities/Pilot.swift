//
//  Pilot.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Foundation

/// used for user registration
struct Pilot: Equatable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let license: LicenseType
    
    init(id: UUID = UUID(),
         firstName: String,
         lastName: String,
         license: LicenseType) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.license = license
    }
    
    static func == (lhs: Pilot, rhs: Pilot) -> Bool {
        return lhs.id == rhs.id
        && lhs.firstName == rhs.firstName
        && lhs.lastName == rhs.lastName
        && lhs.license == rhs.license
    }
}

@MainActor
extension Pilot {
    static let testPilot = Pilot(firstName: "Phil",
                                 lastName: "Flieger",
                                 license: PilotLicense.testLicenses[0].type)
}
