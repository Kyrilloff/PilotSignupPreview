//
//  AppStateTests.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 27.02.25.
//

import Testing
@testable import PilotSignup

@MainActor
struct AppStateTests {
    var sut: AppState
    let mockNetworkService = AppDataNetworkServiceMock()
    let mockLocalStorageService = AppDataLocalStorageServiceMock()
    var mockRepository = AppDataRepositoryMock()
    
    init() async throws {
        self.sut = AppState(appDataRepository: mockRepository)
    }
    
    @Test("Load License Data Failure")
    func loadLicenseDataFailure() async throws {
        mockRepository.loadLicenseDataSucceeds = false
        let licenseDataBeforeLoading = sut.licenseData
        #expect(licenseDataBeforeLoading.isEmpty)
        
        do {
            try await sut.loadLicenseData()
        } catch {
            #expect(error as? NetworkError == .dataLoadingFailure)
        }
        
        let licenseDataAfterLoading = sut.licenseData
        #expect(licenseDataAfterLoading.isEmpty)
    }
    
    @Test("Load License Data Success")
    func loadLicenseDataSuccess() async throws {
        mockRepository.loadLicenseDataSucceeds = true
        let licenseDataBeforeLoading = sut.licenseData
        #expect(licenseDataBeforeLoading.isEmpty)
        
        try await sut.loadLicenseData()
        
        let licenseDataAfterLoading = sut.licenseData
        #expect(licenseDataAfterLoading.isEmpty == false)
    }
    
    @Test("Get License Failure")
    func getLicenseFailure() async throws {
        mockRepository.loadLicenseDataSucceeds = false
        let testLicense = PilotLicense.testLicenses[0]
        
        do {
            _ = try await sut.getLicense(for: testLicense.type)
        } catch {
            #expect(error as? NetworkError == .dataLoadingFailure)
        }

        let licenseData = sut.licenseData
        #expect(licenseData.isEmpty)
        
    }
    
    @Test("Get License Success")
    func getLicenseSuccess() async throws {
        mockRepository.loadLicenseDataSucceeds = true
        let testLicense = PilotLicense.testLicenses[0]
        let loadedLicense = try await sut.getLicense(for: testLicense.type)
        
        let licenseData = sut.licenseData
        #expect(licenseData.isEmpty == false)
        #expect(testLicense == loadedLicense)
    }
}
