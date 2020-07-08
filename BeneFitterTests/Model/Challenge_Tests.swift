//
//  Challenge_Tests.swift
//  BeneFitterTests
//
//  Created by Mattias Törnqvist on 2020-07-08.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import XCTest
@testable import BeneFitter

class Challenge_Tests: XCTestCase {

    var sut: Challenge!
    var challengeId: String!
    var mockResponse: MockSelfChallengeResponse!
    var invalidDict: [String : Any]!
    var validDict: [String : Any]!

    override func setUp() {
        challengeId = "1"
        mockResponse = MockSelfChallengeResponse()
        validDict = mockResponse.validDict
        invalidDict = ["betting_amount" : ""]
        sut = Challenge(challengeId: challengeId)
    }
    
    func test_twenty_is_valid_bet() throws {
        XCTAssertNoThrow( try sut.selfChallenge(dict: validDict))
    }

    func test_empty_string_is_invalid_bet() throws {
        let expectedError = ChallengeError.invalidBet
        var error: ChallengeError?
        XCTAssertThrowsError(try sut.selfChallenge(dict: invalidDict)) {
            thrownError in
            error = thrownError as? ChallengeError
        }

        XCTAssertEqual(expectedError, error)
    }

}
