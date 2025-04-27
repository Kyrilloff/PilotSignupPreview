//
//  ConfirmationScreen.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import SwiftUI
import UIComponents

/// confirms registration, displays basic user data, and allows to log out
struct ConfirmationScreen: View {
    
    // Environments + View Model
    @State private var vm = ConfirmationScreenViewModel()
    @Environment(UserState.self) var userState
    @Environment(AppState.self) var appState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            if let currentUser = userState.currentUser {
                Spacer().frame(height: Height.standard)
                
                // Welcome Message
                Text(String(
                    format: "Confirmation.WelcomeMessage".localized,
                    currentUser.firstName,
                    currentUser.lastName
                ))
                .font(.largeTitle)
                .bold()
                
                Spacer().frame(height: Height.small)
                
                // License Type
                Text(String(
                    format: "Confirmation.LicenseType".localized,
                    currentUser.license.name
                ))
                .font(.title)
                
                Spacer().frame(height: Height.large)
                
                // Aircraft List
                if let operatableAircrafts = vm.operatableAircrafts {
                    Text("Confirmation.AllowedAircrafts")
                        .font(.headline)
                    
                    List {
                        ForEach(operatableAircrafts) { aircraft in
                            Text(aircraft.name)
                        }
                    }
                    .listStyle(.plain)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, Padding.standard)
        // Navigation
        .navigationTitle("Confirmation.Navbar.Title")
        .navigationBarTitleDisplayMode(horizontalSizeClass == .compact ? .inline : .large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Confirmation.Navbar.Logout") {
                    vm.showLogoutWarning = true
                }
                .foregroundStyle(.red)
                .accessibilityIdentifier("logoutButton")
            }
        }
        // Data
        .task {
            guard let currentUser = userState.currentUser else {
                dismiss()
                return
            }
            
            do {
                let licenseData = try await appState.getLicense(for: currentUser.license)
                vm.operatableAircrafts = licenseData?.aircrafts.sorted { $0.name < $1.name }
            } catch {
                log.error("Loading license data failed with error \(error)")
            }
        }
        .onChange(of: userState.currentUser) { _, newValue in
            if newValue == nil {
                dismiss()
            }
        }
        // Alerts
        .alert("Confirmation.Alert.Title",
               isPresented: $vm.showLogoutWarning) {
            Button("Confirmation.Alert.Confirm", role: .destructive) {
                vm.logoutUser(userState: userState)
            }
            .accessibilityIdentifier("logoutConfirmButton")
            
            Button("Confirmation.Alert.Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Preview
#Preview {
    let userState = UserState()
    userState.currentUser = Pilot.testPilot
    
    return NavigationStack {
        ConfirmationScreen()
            .environment(userState)
            .environment(AppState())
    }
}
