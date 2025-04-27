//
//  StandardButton.swift
//  UIComponents
//
//  Created by Konrad Schmid on 20.02.25.
//

import SwiftUI

/// defines custom button
public struct StandardButton: View {
    let text: String
    let disabled: Bool
    let action: () -> ()
    @Binding var loading: Bool
    
    public init(text: String,
                disabled: Bool = false,
                loading: Binding<Bool> = .constant(false),
                action: @escaping () -> Void) {
        self.text = text
        self.disabled = disabled
        _loading = loading
        self.action = action
    }
    
    public var body: some View {
        Button(action: action,
               label: {
            HStack(alignment: .center) {
                Text(text)
                
                if loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .controlSize(.small)
                        .padding(.leading, Padding.small)
                }
            }
            .frame(height: Height.large)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(Color.appPrimary)
            .bold()
            .opacity(disabled ? Opacity.medium : Opacity
                .none)
        })
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.standard))
        .disabled(disabled || loading)
    }
}

#Preview {
    StandardButton(text: "Button Name", loading: .constant(true)) {
        print("button was tapped")
    }
}
