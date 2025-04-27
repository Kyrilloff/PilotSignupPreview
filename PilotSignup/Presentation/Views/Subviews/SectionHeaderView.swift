//
//  SectionHeaderView.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import SwiftUI

/// displays a headline if there is one
struct SectionHeaderView: View {
    var headline: String
    
    var body: some View {
        if !headline.isEmpty {
            Text(LocalizedStringKey(headline))
                .foregroundStyle(.black)
                .bold()
        }
    }
}

#Preview {
    SectionHeaderView(headline: "This is a headline")
}
