//
//  TopChallengeModel.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-07-02.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

struct TopChallengeModel: TopChallengeInterface {
    let image: UIImage
    let titleLabel: String
    let textBody: String
    let typeOfChallenge: TypeOfChallenge
    let challengeGoal: Int
    let duration: Duration
    let charityOrganization: CharityOrganization
    let bet: ChallengeGoal
    var userHasJoined: Bool
    let isTopChallenge = true
}
