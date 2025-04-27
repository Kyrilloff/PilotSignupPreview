//
//  RegistrationScreenViewModel.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 22.04.25.
//

import Observation

@Observable
class RegistrationScreenViewModel {
    
    // Properties
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    var passwordRepeat: String = ""
    var licenseTypes = [LicenseType]()
    var selectedLicenseType: LicenseType?
    
    var passwordError: TextfieldError?
    var checkForPasswordErrors = false
}

// methods
extension RegistrationScreenViewModel {
    // registration
    @MainActor
    func registerPilot(userState: UserState) async throws {
        guard let selectedLicenseType else { return }
        let pilot = Pilot(firstName: firstName.trimmedWhitespaces,
                          lastName: lastName.trimmedWhitespaces,
                          license: selectedLicenseType)
        
        try await userState.registerNewPilot(pilot, password: password)
    }
    
    // validation
    func isNameValid(_ name: String) -> Bool {
        name.containsNonWhitespace
    }
    
    func isPasswordValid() -> Bool {
        password.count >= 12
        && password.containsUppercase
        && password.containsLowercase
        && password.containsNumber
        && !passwordContainsUsername()
    }
    
    private func passwordContainsUsername() -> Bool {
        password.lowercased().contains(firstName.lowercased())
        || password.lowercased().contains(lastName.lowercased())
    }
    
    private func doPasswordsMatch() -> Bool {
        password == passwordRepeat
    }
    
    func checkAndSetPasswordError() {
        guard !password.isEmpty || !passwordRepeat.isEmpty else {
            passwordError = nil
            return
        }
        
        if checkForPasswordErrors {
            if passwordContainsUsername() {
                passwordError = .containsUsername
            } else if !isPasswordValid() {
                passwordError = .incorrect
            } else if !doPasswordsMatch() && !passwordRepeat.isEmpty {
                passwordError = .mismatch
            } else {
                passwordError = nil
            }
        }
    }
    
    func isRegisterButtonDisabled() -> Bool {
        !isNameValid(firstName)
        || !isNameValid(lastName)
        || !doPasswordsMatch()
        || !isPasswordValid()
        || !isLicenseSelected()
    }
    
    private func isLicenseSelected() -> Bool {
        return selectedLicenseType != nil
    }
    
    
    // cleanup
    func cleanupTextfields() {
        checkForPasswordErrors = false
        firstName = ""
        lastName = ""
        password = ""
        passwordRepeat = ""
        selectedLicenseType = nil
        passwordError = nil
    }
}
