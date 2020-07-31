//
//  Errors.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-07-06.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidUserInfo
    case errorCreatingUser
    case invalidData
    case userNotLoggedIn
    
    var errorDescription: String? {
        switch self {
        case .invalidUserInfo:
            return "Invalid user info provided, check that you have provided all necessary info"
        case .errorCreatingUser:
            return "Error creating user in database"
        case .invalidData:
            return "Invalid data!"
        case .userNotLoggedIn:
            return "User is not logged in"
        }
    }
}

enum ChallengeError: LocalizedError {
    case uploadError
    case invalidBet
    case invalidChallengeType
    case invalidCharityOrganization
    case invalidDuration
    case invalidStartDate
    case invalidIsTopChallenge
    case invalidProgress
    case invalidGoal
    
    var errorDescription: String? {
        switch self {
        case .uploadError:
            return "Error uploading challenge to server"
        case .invalidChallengeType:
            return "Error invalid challenge type"
        case .invalidBet:
            return "Error invalid bet"
        case .invalidCharityOrganization:
            return "Error invalid charity organization"
        case .invalidDuration:
            return "Error invalid duration"
        case .invalidStartDate:
            return "Error invalid start date"
        case .invalidIsTopChallenge:
            return "Error invalid top challenge description in database"
        case .invalidProgress:
            return "Error invalid progress in database"
        case .invalidGoal:
            return "Error invalid goal in database"
        }
    }
}

enum DateError: LocalizedError {
    case invalidDate
    
    var errorDescription: String? {
        switch self {
        case .invalidDate:
            return "Error invalid date"
        }
    }
}
