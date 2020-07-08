//
//  Constants.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-27.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation
import Firebase

let REF = Database.database().reference()
let REF_USERS = REF.child("users")
let REF_CHALLENGES = REF.child("challenges")
let REF_SELF_CHALLENGES = REF_CHALLENGES.child("self_challenges")
let REF_CHARITY_ORGANIZATIONS = REF.child("charity_organizations")
let TOP_CHALLENGE_IDENTIFIER = 1
//let REF_CHARITY_ORGANIZATIONS_ACTIVE_CHALLENGES = REF_CHARITY_ORGANIZATIONS.child("active_challenges")

//let DB = Storage.storage().re

enum TypeOfChallenge: String {
    case mostCaloriesBurnt
    case maxSteps
    
    var progress: Int {
        switch self {
        case .mostCaloriesBurnt:
            return 0
        default:
            return 0
        }
    }
}

enum CharityOrganization: String {
    case hjartOchLungFonden
    
    var name: String {
        switch self {
        case .hjartOchLungFonden:
            return "Hjärt- & Lungfonden"
        }
    }
    
    var id: String {
        switch self {
        case .hjartOchLungFonden:
            return "1"
        }
    }
    
    var swishNumber: Int {
        switch self {
        case .hjartOchLungFonden:
            return 9091927
        }
    }
    
    var logotypeImagePath: String {
        switch self {
        case .hjartOchLungFonden:
            return "gs://benefitter-76af5.appspot.com/charity_organizations/logotypes/1/HLF-logotyp.png"
        }
    }
}

enum ChallengeGoal {
    case mostCaloriesBurnt
    case maxSteps
    
    var topChallengeGoal: Int {
        switch self {
        case .maxSteps:
            return 10000
        case .mostCaloriesBurnt:
            return 500
        }
    }
    
    var topChallengeBet: Int {
        switch self {
        case .maxSteps:
            return 20
        case .mostCaloriesBurnt:
            return 20
        }
    }
    
    var topChallengeDescription: String {
        switch self {
        case .mostCaloriesBurnt:
            return "calories"
        case .maxSteps:
            return "steps"
        }
    }
}

enum Duration: TimeInterval {
    case twentyFourHours = 86400
    
    var durationInSeconds: TimeInterval {
        switch self {
        case .twentyFourHours:
            return TimeInterval.init(86400)
        }
    }
    
    var durationInHours: Int {
        switch self {
        case .twentyFourHours:
            return 24
        }
    }
}
