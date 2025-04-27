//
//  AppDataRepositoryTests.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 20.02.25.
//

import Testing
@testable import PilotSignup

@MainActor
struct AppDataRepositoryTests {
    var sut: AppDataRepository
    let mockNetworkService = AppDataNetworkServiceMock()
    let mockLocalStorageService = AppDataLocalStorageServiceMock()
    
    init() {
        self.sut = AppDataRepository(networkService: mockNetworkService,
                                     localStorageService: mockLocalStorageService)
    }
    
    @Test("Load License Data Success")
    func loadLicenseDataSuccess() async throws {
        mockNetworkService.loadLicenseDataSucceeds = true
        mockLocalStorageService.loadLicenseDataSucceeds = true
        mockLocalStorageService.storeLicenseDataSucceeds = true
        
        do {
            let licenseData = try await sut.loadLicenseData()
            #expect(licenseData != nil)
            #expect(!licenseData.isEmpty)
        } catch {
            #expect(error == nil, "Unexpected error: \(error)")
        }
    }
    
    @Test("Load License Data Network Failure")
    func loadLicenseDataNetworkFailure() async throws {
        mockNetworkService.loadLicenseDataSucceeds = false
        
        do {
            let licenseData = try await sut.loadLicenseData()
            #expect(licenseData == nil, "Unexpected result")
        } catch {
            #expect(error as! NetworkError == .dataLoadingFailure)
        }
    }
    
    @Test("Load License Data Local Storage Storage Failure")
    func loadLicenseDataLocalStorageStorageFailure() async throws {
        mockNetworkService.loadLicenseDataSucceeds = true
        mockLocalStorageService.storeLicenseDataSucceeds = false
        mockLocalStorageService.loadLicenseDataSucceeds = true
        
        do {
            let licenseData = try await sut.loadLicenseData()
            #expect(licenseData == nil, "Unexpected result")
        } catch {
            #expect(error as! LocalStorageError == .storingFailed)
        }
    }
    
    @Test("Load License Data Local Storage Fetching Failure")
    func loadLicenseDataLocalStorageFetchingFailure() async throws {
        mockNetworkService.loadLicenseDataSucceeds = true
        mockLocalStorageService.storeLicenseDataSucceeds = true
        mockLocalStorageService.loadLicenseDataSucceeds = false
        
        do {
            let licenseData = try await sut.loadLicenseData()
            #expect(licenseData == nil, "Unexpected result")
        } catch {
            #expect(error as! LocalStorageError == .loadingFailed)
        }
    }
    
}
