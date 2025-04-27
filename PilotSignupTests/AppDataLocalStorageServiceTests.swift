//
//  AppDataLocalStorageServiceTests.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 26.02.25.
//

import Foundation
import Testing
@testable import PilotSignup

@MainActor
struct AppDataLocalStorageServiceTests {
    var sut: AppDataLocalStorageService
    
    init() {
        let persistence = PersistenceController(forTesting: true)
        let context = persistence.container.viewContext
        self.sut = AppDataLocalStorageService(context: context)
    }
    
    @Test("Save License Data Success")
    func saveLicenseDataSuccess() async throws {
        do {
            try await sut.saveLicenseData(PilotLicense.testLicenses)
        } catch {
            #expect(error == nil, "Unexpected error: \(error)")
        }
    }
    
    @Test("Get License Data Success")
    func getLicenseDataSuccess() async throws {
        do {
            let testLicenses = PilotLicense.testLicenses
            try await sut.saveLicenseData(testLicenses)
            let localLicenseData = try await sut.getLicenseData()
            
            #expect(!localLicenseData.isEmpty)
            #expect(localLicenseData.count == testLicenses.count)
            #expect(localLicenseData.sorted(by: { $0.id < $1.id }) == testLicenses.sorted(by: { $0.id < $1.id }))
        } catch {
            #expect(error == nil, "Unexpected error: \(error)")
        }
    }
    
    @Test("Update License Data Success")
    func updateLicenseDataSuccess() async throws {
        do {
            let originalLicenseData = PilotLicense.testLicenses
            try await sut.saveLicenseData(originalLicenseData)
            let licenseDataBeforeUpdate = try await sut.getLicenseData()
            
            let newAircraftId = UUID()
            let newAircraftName = "New Aircraft Name"
            let newAircraft = Aircraft(id: newAircraftId,
                                       name: newAircraftName)
            
            var updatedLicenseData = licenseDataBeforeUpdate
            updatedLicenseData[0].aircrafts.append(newAircraft)

            try await sut.saveLicenseData(updatedLicenseData)
            let licenseDataAfterUpdate = try await sut.getLicenseData()
            
            #expect(licenseDataBeforeUpdate != licenseDataAfterUpdate)
            #expect(licenseDataBeforeUpdate[0].aircrafts.count != licenseDataAfterUpdate[0].aircrafts.count)
            #expect(licenseDataAfterUpdate[0].aircrafts.contains(newAircraft))
        } catch {
            #expect(error == nil, "Unexpected error: \(error)")
        }
    }
}
