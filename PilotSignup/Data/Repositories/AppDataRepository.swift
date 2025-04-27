//
//  AppDataRepository.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Foundation

@MainActor
protocol AppDataRepositoryProtocol {
    func loadLicenseData() async throws -> [PilotLicense]
}

/// handles general app data between data layer (network / local storage services) and presentation layer / view model (app state)
class AppDataRepository: AppDataRepositoryProtocol {
    let networkService: AppDataNetworkServiceProtocol
    let localStorageService: AppDataLocalStorageServiceProtocol
    
    init(networkService: AppDataNetworkServiceProtocol = AppDataNetworkService(),
    localStorageService: AppDataLocalStorageServiceProtocol = AppDataLocalStorageService()) {
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    func loadLicenseData() async throws -> [PilotLicense] {
        // loading from network (API)
        let licenseData = try await networkService.loadLicenseData()
        
        // storing locally (Core Data)
        try await localStorageService.saveLicenseData(licenseData)
        let localLicenseData = try await localStorageService.getLicenseData()
        return localLicenseData
    }
}
