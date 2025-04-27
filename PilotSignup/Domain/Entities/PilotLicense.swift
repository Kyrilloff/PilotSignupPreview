//
//  PilotLicense.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Foundation

/// license that is used for user registration
struct PilotLicense: Codable, Equatable, Identifiable {
    let id: UUID // id is added for possible later use in local storage and network services
    let type: LicenseType
    var aircrafts: [Aircraft]
    
    init(id: UUID = UUID(),
         type: LicenseType,
         aircrafts: [Aircraft]) {
        self.id = id
        self.type = type
        self.aircrafts = aircrafts.sorted { $0.name < $1.name }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case aircrafts
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeName = try container.decode(String.self, forKey: .type)
        type = LicenseType(name: typeName)
        
        let aircraftNames = try container.decode([String].self, forKey: .aircrafts).sorted()
        aircrafts = aircraftNames.map { name in
            Aircraft(name: name)
        }
        
        id = UUID()
    }
    
    static func == (lhs: PilotLicense, rhs: PilotLicense) -> Bool {
        return lhs.type == rhs.type
        && lhs.aircrafts == rhs.aircrafts

    }
}

extension PilotLicense {
    static let testLicenses = [
        PilotLicense(type: LicenseType(name: "HPL"),
                     aircrafts: [
                        Aircraft(name: "H120"),
                        Aircraft(name: "R44"),
                        Aircraft(name: "EC135")
                     ]),
        PilotLicense(type: LicenseType(name: "eVTOL-A"),
                     aircrafts: [
                        Aircraft(name: "VX4"),
                        Aircraft(name: "E200")
                     ]),
        PilotLicense(type: LicenseType(name: "eVTOL-B"),
                     aircrafts: [
                        Aircraft(name: "VoloCity"),
                        Aircraft(name: "JobyS4"),
                        Aircraft(name: "CityAirbus")
                     ])
    ]
}
