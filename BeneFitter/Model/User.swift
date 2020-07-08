//
//  User.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-28.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let fullname: String
    let selfChallenges: [SelfChallenge]?
    
    init(_ uid: String, _ fullname: String, _ selfChallenges: [SelfChallenge]?) {
        self.uid = uid
        self.fullname = fullname
        self.selfChallenges = selfChallenges

    }
}
