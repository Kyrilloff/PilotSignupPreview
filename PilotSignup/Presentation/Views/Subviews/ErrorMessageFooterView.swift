//
//  ErrorFooterView.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import SwiftUI

/// displays an error message when binding is not nil
struct ErrorMessageFooterView: View {
    @Binding var error: TextfieldError?
    
    var body: some View {
        if let error {
            Text(LocalizedStringKey(error.rawValue))
                .bold()
                .foregroundStyle(Color.appSignal)
        }
    }
}

#Preview {
    ErrorMessageFooterView(error: .constant(.incorrect))
}
