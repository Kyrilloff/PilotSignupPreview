//
//  RegistrationScreen.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import SwiftUI
import UIComponents

/// handles registration based on loaded app data and specific constraints for input data
struct RegistrationScreen: View {
    
    enum FocusedField {
        case firstName, lastName
        case password, passwordRepeat
    }
    
    // Environments + View Model
    @State private var vm = RegistrationScreenViewModel()
    @Environment(AppState.self) var appState
    @Environment(UserState.self) var userState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // View States
    @State private var showConfirmationScreen = false
    @State private var showLoadingIndicator = false
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            Form {
                // Name Section
                Section {
                    TextField("Registration.Textfield.FirstName.Placeholder",
                              text: $vm.firstName)
                    .focused($focusedField, equals: .firstName)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .lastName
                    }
                    .accessibilityIdentifier("firstNameTextField")
                    
                    TextField("Registration.Textfield.LastName.Placeholder",
                              text: $vm.lastName)
                    .focused($focusedField, equals: .lastName)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                    .accessibilityIdentifier("lastNameTextField")
                    
                } header: {
                    SectionHeaderView(headline: "Registration.Section.Name.Headline")
                }
                
                // Password Section
                Section {
                    SecureField("Registration.Textfield.Password.Placeholder",
                                text: $vm.password)
                    .focused($focusedField, equals: .password)
                    .textContentType(.oneTimeCode) // prevents system autofill
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .passwordRepeat
                    }
                    .accessibilityIdentifier("passwordTextField")
                    
                    SecureField("Registration.Textfield.PasswordRepeat.Placeholder",
                                text: $vm.passwordRepeat)
                    .focused($focusedField, equals: .passwordRepeat)
                    .textContentType(.oneTimeCode) // prevents system autofill
                    .submitLabel(.return)
                    .onSubmit {
                        focusedField = nil
                    }
                    .accessibilityIdentifier("passwordRepeatTextField")
                    
                } header: {
                    PasswordSectionHeaderView()
                } footer: {
                    ErrorMessageFooterView(error: $vm.passwordError)
                }
                
                // License Section
                Section {
                    if !vm.licenseTypes.isEmpty {
                        Picker("Registration.Section.License.Picker.Headline", selection: $vm.selectedLicenseType) {
                            // nil default value to make sure that a valid license type is actively selected
                            Text("Registration.Section.License.Picker.NoLicenseValue")
                                .tag(Optional<LicenseType>.none)
                            
                            ForEach(vm.licenseTypes) { licenseType in
                                Text(licenseType.name)
                                    .tag(licenseType)
                            }
                        }
                        .pickerStyle(.menu)
                        .accessibilityIdentifier("licensePicker")
                    }
                    
                } header: {
                    SectionHeaderView(headline: "Registration.Section.License.Headline")
                }
            }
            
            // RegisterButton
            StandardButton(text: String(localized: "Registration.Button.Register.Title"),
                           disabled: vm.isRegisterButtonDisabled(),
                           loading: $showLoadingIndicator) {
                Task {
                    showLoadingIndicator = true
                    
                    do {
                        try await vm.registerPilot(userState: self.userState)
                        showLoadingIndicator = false
                    } catch {
                        log.error("Registration failed with error \(error)")
                        showLoadingIndicator = false
                    }
                }
            }.padding(.horizontal, Padding.standard)
                .padding(.vertical, Padding.extraSmall)
                .accessibilityIdentifier("registerButton")
        }
        // Navigation
        .navigationTitle("Registration.Navbar.Title")
        .toolbarTitleDisplayMode(horizontalSizeClass == .compact ? .inline : .large)
        .navigationDestination(isPresented: $showConfirmationScreen) {
            ConfirmationScreen()
        }
        // Data
        .task {
            do {
                try await appState.loadLicenseData()
                vm.licenseTypes = appState.licenseData
                    .map { $0.type }
                    .sorted { $0.name < $1.name }
            } catch {
                log.error("Loading app data failed with error \(error)")
            }
            
            vm.checkForPasswordErrors = true
        }
        .onChange(of: userState.currentUser) { _, newValue in
            if newValue != nil {
                showConfirmationScreen = true
                vm.cleanupTextfields()
            }
        }
        .onChange(of: vm.password) { _, _ in
            vm.checkAndSetPasswordError()
        }
        .onChange(of: vm.passwordRepeat) { _, _ in
            vm.checkAndSetPasswordError()
        }
        .onChange(of: vm.firstName) { _, _ in
            vm.checkAndSetPasswordError()
        }
        .onChange(of: vm.lastName) { _, _ in
            vm.checkAndSetPasswordError()
        }
        .onDisappear {
            focusedField = nil
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        RegistrationScreen()
            .environment(AppState())
            .environment(UserState())
    }
}
