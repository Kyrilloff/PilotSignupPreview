//
//  CDAircraft.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 25.02.25.
//

import CoreData

extension CDAircraft {
    
    var aircraft: Aircraft? {
        guard let id,
              let name else {
            log.error("Casting CDAircraft to Aircraft failed due to lack of data")
            return nil
        }
        return Aircraft(id: id, name: name)
    }
}
