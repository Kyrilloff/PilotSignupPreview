//
//  AppDataLocalStorageService.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 25.02.25.
//

import CoreData

@MainActor
protocol AppDataLocalStorageServiceProtocol {
    func saveLicenseData(_ appData: [PilotLicense]) async throws
    func getLicenseData() async throws -> [PilotLicense]
}

struct AppDataLocalStorageService: AppDataLocalStorageServiceProtocol {

    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func saveLicenseData(_ appData: [PilotLicense]) async throws {
        try await CDPilotLicense.saveOrUpdateLicenses(appData,
                                                      context: context)
    }
    
    func getLicenseData() async throws -> [PilotLicense] {
        try await CDPilotLicense.loadLicenses(context: context)
    }
}
