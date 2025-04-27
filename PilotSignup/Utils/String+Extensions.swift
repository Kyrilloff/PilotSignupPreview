//
//  String+Extensions.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 20.02.25.
//

import Foundation

extension String {
    // ensures at least one non-whitespace character is contained
    var containsNonWhitespace: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // ensures that the string contains at last one uppercase letter
    var containsUppercase: Bool {
        self.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    // ensures that the string contains at last one lowercase letter
    var containsLowercase: Bool {
        self.rangeOfCharacter(from: .lowercaseLetters) != nil
    }
    
    // ensures that the string contains at last one number
    var containsNumber: Bool {
        self.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    // trims whitespaces at start and end of a string
    var trimmedWhitespaces: String {
        self.trimmingCharacters(in: .whitespaces)
    }
    
    // facilitates localization with injected values
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

// Regex alternatives
extension String {
    // Ensures at least one non-whitespace character is contained
    var containsNonWhitespaceRegex: Bool {
        self.range(of: #"(?=\S)"#, options: .regularExpression) != nil
    }
    
    // Ensures that the string contains at least one uppercase letter
    var containsUppercaseRegex: Bool {
        self.range(of: #"[A-Z]"#, options: .regularExpression) != nil
    }
    
    // Ensures that the string contains at least one lowercase letter
    var containsLowercaseRegex: Bool {
        self.range(of: #"[a-z]"#, options: .regularExpression) != nil
    }
    
    // Ensures that the string contains at least one number
    var containsNumberRegex: Bool {
        self.range(of: #"\d"#, options: .regularExpression) != nil
    }
    
    // Trims whitespaces at start and end of a string (regex version)
    var trimmedWhitespacesRegex: String {
        self.replacingOccurrences(of: #"^\s+|\s+$"#, with: "", options: .regularExpression)
    }
}
