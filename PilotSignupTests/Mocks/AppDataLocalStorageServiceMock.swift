//
//  AppDataLocalStorageServiceMock.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 26.02.25.
//

@testable import PilotSignup

class AppDataLocalStorageServiceMock: AppDataLocalStorageServiceProtocol {
    var storeLicenseDataSucceeds: Bool = false
    var storeLicenseDataErrorResult = LocalStorageError.storingFailed
    
    var loadLicenseDataSucceeds: Bool = false
    var loadLicenseDataSuccessResult = PilotLicense.testLicenses
    var loadLicenseDataErrorResult = LocalStorageError.loadingFailed
    
    func saveLicenseData(_ appData: [PilotSignup.PilotLicense]) async throws {
        if !storeLicenseDataSucceeds {
            throw storeLicenseDataErrorResult
        }
    }
    
    func getLicenseData() async throws -> [PilotSignup.PilotLicense] {
        if loadLicenseDataSucceeds {
            return loadLicenseDataSuccessResult
        } else {
            throw loadLicenseDataErrorResult
        }
    }
}
