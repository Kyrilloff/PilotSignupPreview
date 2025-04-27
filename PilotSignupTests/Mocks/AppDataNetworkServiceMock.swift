//
//  AppDataNetworkServiceMock.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 20.02.25.
//

@testable import PilotSignup

class AppDataNetworkServiceMock: AppDataNetworkServiceProtocol {
    var loadLicenseDataSucceeds = false
    var loadLicenseDataSuccessResult = PilotLicense.testLicenses
    var loadLicenseDataErrorResult = NetworkError.dataLoadingFailure
    
    func loadLicenseData() async throws -> [PilotLicense] {
        if loadLicenseDataSucceeds {
            return loadLicenseDataSuccessResult
        } else {
            throw loadLicenseDataErrorResult
        }
    }
}
