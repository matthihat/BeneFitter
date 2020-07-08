//
//  MockDict.swift
//  BeneFitterTests
//
//  Created by Mattias Törnqvist on 2020-07-08.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation

struct MockSelfChallengeResponse {
    let validDict : [String : Any] = [
        "betting_amount" : 20,
        "challenge_type" : "mostCaloriesBurnt",
        "charity_organization" : "hjartOchLungFonden",
        "duration_seconds" : 86400.0,
        "start_date" : "2020-07-06 14:38:33 +0000",
        "is_top_challenge" : true
    ]
}
