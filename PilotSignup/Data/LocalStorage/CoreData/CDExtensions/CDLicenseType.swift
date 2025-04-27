//
//  CDLicenseType.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 26.02.25.
//

import Foundation

extension CDLicenseType {
    
    var licenseType: LicenseType? {
        guard let id,
              let name else {
            log.error("Casting CDLicenseType to LicenseType failed due to lack of data")
            return nil
        }
        return LicenseType(id: id, name: name)
    }
}
