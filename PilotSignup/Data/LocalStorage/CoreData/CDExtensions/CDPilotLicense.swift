//
//  CDLicenseType.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 25.02.25.
//

import CoreData

@MainActor
extension CDPilotLicense {
    static func loadLicenses(context: NSManagedObjectContext) async throws -> [PilotLicense] {
        log.info("Fetching local license data")
        
        let fetchRequest: NSFetchRequest<CDPilotLicense> = CDPilotLicense.fetchRequest()
        
        let result = try context.fetch(fetchRequest)
        return result.compactMap(\.pilotLicense)
    }
    
    static func saveOrUpdateLicenses(_ licenses: [PilotLicense], context: NSManagedObjectContext) async throws {
        
        var updatedLicenses: [PilotLicense] = []
        for license in licenses {
            if let existingLicense = try await fetchLicense(with: license.type.name, context: context) {
                
                if existingLicense.pilotLicense != license {
                    // update
                    try await updateLicense(existingLicense,
                                            with: license,
                                            context: context)
                    updatedLicenses.append(license)
                }
            } else {
                // create
                try await createLicense(license, context: context)
            }
        }
        
        if updatedLicenses.isEmpty {
            log.info("No licenses updated as API data matches local data")
        } else {
            log.info("Updated licenses: \(updatedLicenses.map { $0.type.name })")
        }
    }
    
    private static func fetchLicense(with id: UUID,
                                     context: NSManagedObjectContext)  async throws -> CDPilotLicense? {
        let request = CDPilotLicense.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }
    
    private static func fetchLicense(with typeName: String,
                                     context: NSManagedObjectContext)  async throws -> CDPilotLicense? {
        let request = CDPilotLicense.fetchRequest()
        request.predicate = NSPredicate(format: "type.name == %@", typeName as CVarArg)
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }
    
    private static func createLicense(_ license: PilotLicense,
                                      context: NSManagedObjectContext) async throws {
        
        log.info("Storing new pilot license")
        
        let cdLicense = CDPilotLicense(context: context)
        cdLicense.id = license.id
        
        let cdLicenseType = CDLicenseType(context: context)
        cdLicenseType.id = license.type.id
        cdLicenseType.name = license.type.name
        
        cdLicense.type = cdLicenseType
        
        var aircrafts: Set<CDAircraft> = []
        for aircraft in license.aircrafts {
            let cdAircraft = CDAircraft(context: context)
            cdAircraft.id = aircraft.id
            cdAircraft.name = aircraft.name
            
            aircrafts.insert(cdAircraft)
        }
        
        cdLicense.aircrafts = Set(aircrafts) as NSSet
        
        try context.save()
    }
    
    private static func updateLicense(_ existingLicense: CDPilotLicense,
                                      with license: PilotLicense,
                                      context: NSManagedObjectContext) async throws {
        
        // update license
        if existingLicense.type?.licenseType != license.type {
            log.info("Updating license in local storage")
            existingLicense.type?.name = license.type.name
        }
        
        // update aircrafts
        guard let aircraftsSet = existingLicense.aircrafts as? Set<CDAircraft> else {
            throw LocalStorageError.castingFailed
        }
        
        log.info("Updating aircrafts in local storage")
        
        let aircrafts = aircraftsSet.map(\.aircraft)
        // only update if there is new data
        if aircrafts != license.aircrafts {
            for updatedAircraft in license.aircrafts {
                if let existingCDAircraft = aircraftsSet.first(where: { $0.id == updatedAircraft.id }) {
                    // Update existing aircraft if anything changed
                    if existingCDAircraft.name != updatedAircraft.name {
                        existingCDAircraft.name = updatedAircraft.name
                    }
                } else {
                    // New aircraft — insert
                    let newCDAircraft = CDAircraft(context: context)
                    newCDAircraft.id = updatedAircraft.id
                    newCDAircraft.name = updatedAircraft.name
                    existingLicense.addToAircrafts(newCDAircraft)
                }
            }
        }
        
        try context.save()
    }
}

extension CDPilotLicense {
    var pilotLicense: PilotLicense? {
        guard let id = id,
              let type = self.type?.licenseType,
              let cdAircrafts = self.aircrafts as? Set<CDAircraft> else {
            log.error("Casting CDPilotLicense to PilotLicense failed due to lack of data")
            return nil
        }
        
        let aircrafts: [Aircraft] = cdAircrafts.compactMap(\.aircraft)
        
        return PilotLicense(
            id: id,
            type: type,
            aircrafts: aircrafts
        )
    }
}
