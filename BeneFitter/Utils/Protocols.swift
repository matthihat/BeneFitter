//
//  Protocols.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-22.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

protocol TopChallengeInterface {
    var image: UIImage { get }
    var titleLabel: String { get }
    var textBody: String { get }
    var typeOfChallenge: TypeOfChallenge { get }
    var challengeGoal: Int { get }
    var duration: Duration { get }
    var charityOrganization: CharityOrganization { get }
    var bet: ChallengeGoal { get }
    var progress: Int { get set }
    var goal: Int { get }
}

protocol SignUpDelegate: class {
    func handleSignUpPressed(_ signUpButton: UIButton, _ fullnameTextField: UITextField, _ emailTextField: UITextField, _ passwordTextField: UITextField)
    
    func alreadyHaveAnAccountButton(_ button: UIButton)
}

protocol LoginDelegate: class {
    func didPressLogin(_ emailTextField: UITextField, _ passwordTextField: UITextField)
    func didPressDontHaveAccountButton(_ button: UIButton)
}

protocol TopChallengeCellDelegate {
    func didPressJoinChallenge(in cell: TopChallengeCell, selected challenge: TopChallengeModel)
}
