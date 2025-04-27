//
//  UserState.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Observation

/// handles user data for views
@MainActor
@Observable
class UserState {
    var currentUser: Pilot?
    let userRepository: UserRepositoryProtocol
    
    init(currentUser: Pilot? = nil,
         userRepository: UserRepositoryProtocol = UserRepository()) {
        self.currentUser = currentUser
        self.userRepository = userRepository
    }
    
    func registerNewPilot(_ pilot: Pilot, password: String) async throws {
        let registeredPilot = try await userRepository.registerPilot(pilot,
                                                                     password: password)
        currentUser = registeredPilot
    }
    
    func logoutCurrentUser() {
        currentUser = nil
    }
}
