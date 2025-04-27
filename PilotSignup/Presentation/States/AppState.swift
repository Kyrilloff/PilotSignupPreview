//
//  AppState.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Observation

/// handles app data for views
@MainActor
@Observable
class AppState {
    let appDataRepository: AppDataRepositoryProtocol
    
    var currentState: CurrentAppState = .registrationFlow
    var licenseData = [PilotLicense]()
    
    init(appDataRepository: AppDataRepositoryProtocol = AppDataRepository()) {
        self.appDataRepository = appDataRepository
    }
    
    func loadLicenseData() async throws {
        licenseData = try await appDataRepository.loadLicenseData()
    }
    
    func getLicense(for type: LicenseType) async throws -> PilotLicense? {
        if licenseData.isEmpty {
            try await loadLicenseData()
        }
        
        return licenseData.first { $0.type.name == type.name }
    }
}

enum CurrentAppState {
    case registrationFlow
    // here other states would be added in order to navigate between different app states
}
