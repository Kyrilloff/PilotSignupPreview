//
//  AppDataRepositoryMock.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 27.02.25.
//

@testable import PilotSignup

class AppDataRepositoryMock: AppDataRepositoryProtocol {
    var loadLicenseDataSucceeds = false
    var loadLicenseDataSuccessResult = PilotLicense.testLicenses
    var loadLicenseDataErrorResult = NetworkError.dataLoadingFailure
    
    func loadLicenseData() async throws -> [PilotSignup.PilotLicense] {
        if loadLicenseDataSucceeds {
            return loadLicenseDataSuccessResult
        } else {
            throw loadLicenseDataErrorResult
        }
    }   
}
