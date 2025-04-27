//
//  ConfirmationScreenViewModel.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 22.04.25.
//

import Observation

@Observable
class ConfirmationScreenViewModel {
    // View States
    var showLogoutWarning = false
    var showRegistration = false
    
    // View Data
    var operatableAircrafts: [Aircraft]?
}

extension ConfirmationScreenViewModel {
    @MainActor
    func logoutUser(userState: UserState) {
        userState.logoutCurrentUser()
    }
}
