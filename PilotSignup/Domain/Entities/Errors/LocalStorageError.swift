//
//  LocalStorageError.swift
//  PilotSignup
//
//  Created by Konrad Schmid on 26.02.25.
//

enum LocalStorageError: Error {
    case couldNotFindData
    case loadingFailed
    case storingFailed
    case castingFailed
}
