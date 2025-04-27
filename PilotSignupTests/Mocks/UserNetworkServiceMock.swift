//
//  UserNetworkServiceMock.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 20.02.25.
//

@testable import PilotSignup

class UserNetworkServiceMock: UserNetworkServiceProtocol {
    var pilotRegistrationSucceeds = false
    var pilotRegistrationSuccessResult = Pilot.testPilot
    var pilotRegistrationErrorResult = NetworkError.dataLoadingFailure
    
    func registerPilot(_ pilot: PilotSignup.Pilot, password: String) async throws -> PilotSignup.Pilot {
        if pilotRegistrationSucceeds {
            return pilotRegistrationSuccessResult
        } else {
            throw pilotRegistrationErrorResult
        }
    }
}
