//
//  AppDataNetworkService.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Foundation

@MainActor
protocol AppDataNetworkServiceProtocol {
    func loadLicenseData() async throws -> [PilotLicense]
}

/// handles general data between App and APIs
struct AppDataNetworkService: AppDataNetworkServiceProtocol {
    
    // loads and decodes license data from json file
    func loadLicenseData() async throws -> [PilotLicense] {
        guard let url = Bundle.main.url(forResource: "PilotLicenses", withExtension: "json") else {
            log.error("Did not find json file")
            throw NetworkError.dataLoadingFailure
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let licenses = try decoder.decode([String: [PilotLicense]].self, from: data)
            
            return licenses.flatMap { $0.value }
        } catch {
            log.error("error while decoding json: \(error)")
            throw error
        }
    }
}
