//
//  UserNetworkService.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

@MainActor
protocol UserNetworkServiceProtocol {
    func registerPilot(_ pilot: Pilot, password: String) async throws -> Pilot
}

/// handles user registration between App and API
struct UserNetworkService: UserNetworkServiceProtocol {
    
    // registers pilot in backend
    func registerPilot(_ pilot: Pilot, password: String) async throws -> Pilot {
        // simulate API response time
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return pilot
    }
}
