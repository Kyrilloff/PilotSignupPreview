//
//  UserRepositoryTests.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 20.02.25.
//

import Testing
@testable import PilotSignup

@MainActor
struct UserRepositoryTests {
    var sut: UserRepository
    let mockNetworkService = UserNetworkServiceMock()
    
    init() {
        sut = UserRepository(networkService: mockNetworkService)
    }
    
    @Test("Register Pilot Success")
    func registerPilotSuccess() async throws {
        let testPilot = Pilot.testPilot
        let testPassword = "1234"
        mockNetworkService.pilotRegistrationSucceeds = true
        
        do {
            let result = try await sut.registerPilot(testPilot,
                                                     password: testPassword)
            #expect(result == testPilot)
        } catch {
            #expect(error == nil, "Unexpected error: \(error)")
        }
    }
    
    @Test("Register Pilot Failure")
    func registerPilotFailure() async throws {
        let testPilot = Pilot.testPilot
        let testPassword = "1234"
        mockNetworkService.pilotRegistrationSucceeds = false
        
        do {
            let result = try await sut.registerPilot(testPilot,
                                                     password: testPassword)
            #expect(result == nil, "Unexpected result")
        } catch {
            #expect(error as! NetworkError == .dataLoadingFailure)
        }
    }
}
