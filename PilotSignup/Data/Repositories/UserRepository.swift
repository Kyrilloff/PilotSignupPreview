//
//  UserRepository.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

@MainActor
protocol UserRepositoryProtocol {
    func registerPilot(_ pilot: Pilot, password: String) async throws -> Pilot
}

struct UserRepository: UserRepositoryProtocol {
    let networkService: UserNetworkServiceProtocol
    
    init(networkService: UserNetworkServiceProtocol = UserNetworkService()) {
        self.networkService = networkService
    }
    
    func registerPilot(_ pilot: Pilot, password: String) async throws -> Pilot {
        try await networkService.registerPilot(pilot,
                                               password: password)
        // usually at this point the registered pilot data would be stored locally (into Core Data or another local database, and sensitive data into the keychain)
    }
}
