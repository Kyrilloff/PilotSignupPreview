//
//  PasswordSectionHeaderView.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import SwiftUI
import UIComponents

/// provides additional information in a Section Hsader via info button / popover
struct PasswordSectionHeaderView: View {
    
    @State private var showPasswordPopover = false
    
    var body: some View {
        HStack {
            // Headline
            SectionHeaderView(headline: "Registration.Section.Password.Headline")
            
            // Button with additional info popover
            Button {
                showPasswordPopover = true
            } label: {
                Image(systemName: "info.circle")
            }
            .popover(isPresented: $showPasswordPopover) {
                VStack(alignment: .leading) {
                    Text("Registration.Section.PasswordRules.Headline")
                        .bold()
                        .foregroundStyle(.black)
                    
                    Spacer().frame(height: Height.small)
                    
                    Text("Registration.Section.PasswordRules.Rules")
                        .textCase(.lowercase)
                        .bold()
                        .foregroundStyle(Color.appSignal)
                        .presentationDetents( [.fraction(0.2), .medium])
                        .presentationDragIndicator(.visible)
                }
                .padding(Padding.extraSmall)
            }
        }
    }
}

#Preview {
    PasswordSectionHeaderView()
}
