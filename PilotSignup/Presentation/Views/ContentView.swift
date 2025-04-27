//
//  ContentView.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    @State private var userState = UserState()
    
    var body: some View {
        VStack {
            switch appState.currentState {
            case .registrationFlow:
                NavigationStack {
                    RegistrationScreen()
                }
            }
        }
        .environment(appState)
        .environment(userState)
    }
}

#Preview {
    ContentView()
}
