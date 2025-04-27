//
//  StringExtensionsTests.swift
//  PilotSignupTests
//
//  Created by Konrad Schmid on 20.02.25.
//

import Testing
@testable import PilotSignup

struct StringExtensionsTests {
    
    @Test("Contains a Non-Whitespace Character Success")
    func containsNonWhitespaceSuccess() {
        let stringWithMoreThanWhitespace = "  m"
        
        #expect(stringWithMoreThanWhitespace.containsNonWhitespace)
    }
    
    @Test("Contains a Non-Whitespace Character Failure")
    func containsNonWhitespaceFailure() {
        let stringWithOnlyWhitespaces = "    "
        
        #expect(!stringWithOnlyWhitespaces.containsNonWhitespace)
    }
    
    @Test("Contains Uppercase Character Success")
    func containsUppercaseSuccess() {
        let stringWithUppercase = "hEllo"
        
        #expect(stringWithUppercase.containsUppercase)
    }
    
    @Test("Contains Uppercase Character Failure")
    func containsUppercaseFailure() {
        let stringWithoutUppercase = "hello"
        
        #expect(!stringWithoutUppercase.containsUppercase)
    }
    
    @Test("Contains Lowercase Character Success")
    func containsLowercaseSuccess() {
        let stringWithLowercase = "HeLLO"
    
        #expect(stringWithLowercase.containsLowercase)
    }
    
    @Test("Contains Lowercase Character Failure")
    func containsLowercaseFailure() {
        let stringWithoutLowercase = "HELLO"
    
        #expect(!stringWithoutLowercase.containsLowercase)
    }
    
    @Test("Contains Number Success")
    func containsNumberSuccess() {
        let stringWithNumber = "H3llo"
        
        #expect(stringWithNumber.containsNumber)
    }
    
    @Test("Contains Number Failure")
    func containsNumberFailure() {
        let stringWithoutNumber = "Hello"
        
        #expect(!stringWithoutNumber.containsNumber)
    }
    
    // parameterised test
    @Test(
        "Trim Whitespaces Success (Parameterised)",
        arguments: TrimWhitespacesInit.allCases
    )
    func trimWhitespacesSuccess(caseData: TrimWhitespacesInit) {
        #expect(caseData.input != caseData.expected)
        
        #expect(caseData.input.trimmedWhitespaces == caseData.expected)
    }
    
    // oldschool test
    @Test("Trim Whitespace Success (non-parameterised)")
    func trimWhitespacesSuccess() {
        let stringWithLeadingWhitespaces = "  Hello"
        let stringWithTrailingWhitespaces = "Hello   "
        let stringWithWhitespacesAtBothEnds = " Hello  "
        let expectedResult = "Hello"
        
        #expect(stringWithLeadingWhitespaces.trimmedWhitespaces == expectedResult)
        #expect(stringWithTrailingWhitespaces.trimmedWhitespaces == expectedResult)
        #expect(stringWithWhitespacesAtBothEnds.trimmedWhitespaces == expectedResult)
    }
    
    // this provides the data for the parameterised trim whitespaces test
    // I would argue that this makes sense when there are a lot of cases to test,
    // but in the current scenario, it creates a lot of boilerplate and decreases readability
    struct TrimWhitespacesInit: CustomStringConvertible, CaseIterable {
        let input: String
        let expected: String = "Hello"
        let description: String
        
        static let allCases: [TrimWhitespacesInit] = [
            .init(input: "  Hello", description: "leading whitespace"),
            .init(input: "Hello   ", description: "trailing whitespace"),
            .init(input: " Hello  ", description: "leading and trailing whitespace")
        ]
    }
    
    @Test("Localized String Success")
    func localizedStringSuccess() {
        let key = "Test.TestString"
        let expectedValue = "Hello"
        
        #expect(key.localized == expectedValue)
    }
    
    @Test("Localized String Failure")
    func localizedStringFailure() {
        let missingKey = "Non.Existent.Key"
        
        // when there is no matching key in the catalogue, the string will be interpreted as value instead
        #expect(missingKey.localized == missingKey)
    }
}
