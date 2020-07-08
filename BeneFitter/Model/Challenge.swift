//
//  Challenge.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-21.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation
import Firebase

protocol ChallengeInterface {
    var challengeId: String { get }
    
    func selfChallenge(dict: [String : Any]) throws -> SelfChallenge
    
}

struct Challenge: ChallengeInterface {
    let challengeId: String
    
    func selfChallenge(dict: [String : Any]) throws -> SelfChallenge {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        guard let bettingAmount = dict["betting_amount"] as? Int else { throw ChallengeError.invalidBet }
        
        guard let challengeDescription = dict["challenge_type"] as? String else { throw ChallengeError.invalidChallengeType }
        
        guard let challengeType = TypeOfChallenge.init(rawValue: challengeDescription) else { throw ChallengeError.invalidChallengeType }
        
        guard let charityOrganization_String = dict["charity_organization"] as? String else { throw ChallengeError.invalidCharityOrganization }
     
        guard let charityOrganization = CharityOrganization.init(rawValue: charityOrganization_String) else { throw ChallengeError.invalidCharityOrganization }
    
        guard let duration_Double = dict["duration_seconds"] as? Double else { throw ChallengeError.invalidDuration }
        
        guard let duration = Duration.init(rawValue: duration_Double) else { throw ChallengeError.invalidDuration }
        
        guard let startDate_String = dict["start_date"] as? String else { throw ChallengeError.invalidStartDate }
        
        guard let startDate = dateFormatter.date(from: startDate_String) else { throw ChallengeError.invalidStartDate }
            
        guard let isTopChallenge = dict["is_top_challenge"] as? Bool else { throw ChallengeError.invalidIsTopChallenge }
        
        let challenge = SelfChallenge(challengeId: challengeId,
                                      challengeType: challengeType,
                                      duration: duration,
                                      startDate: startDate,
                                      charityOrganization: charityOrganization,
                                      isTopChallenge: isTopChallenge,
                                      bettingAmount: bettingAmount)
        return challenge
    }
}

protocol SelfChallengeInterface {
    var challengeId: String { get }
    var challengeType: TypeOfChallenge { get }
    var duration: Duration { get }
    var startDate: Date { get}
    var endDate: Date { get}
    var charityOrganization: CharityOrganization { get }
    var bettingAmount: Int { get }
    
    func postChallenge(completion: @escaping (Result<Bool, Error>) -> Void)
    
}

struct SelfChallenge: SelfChallengeInterface {
    var challengeId: String
    var challengeType: TypeOfChallenge
    var duration: Duration
    var startDate: Date
    
    var endDate: Date {
        let newDate = startDate
        let endDate = newDate.addingTimeInterval(duration.durationInSeconds)
        return endDate
    }
    
    var charityOrganization: CharityOrganization
    
    var isTopChallenge: Bool
    
    var bettingAmount: Int
    
    func postChallenge(completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let group = DispatchGroup()
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            completion(.failure(ChallengeError.uploadError))
            return
        }
        
        let challengeType_String = challengeType.rawValue
        let durationInSeconds = Int(duration.durationInSeconds)
        let startDateString = startDate.description
        let endDateString = endDate.description
        let charityOrganizationIdentifier = charityOrganization.id
        let charityOrganizationName = charityOrganization.name
        let charityOrganizationSwishNumber = charityOrganization.swishNumber
        let charityOrganizationLogotypeImagePath = charityOrganization.logotypeImagePath
        
        let challengeUploadValues: [String:Any] =
                                    [
                                    "challenge_type" : challengeType_String,
                                    "duration_seconds" : durationInSeconds,
                                    "start_date" : startDateString,
                                    "end_date" : endDateString,
                                    "charity_organization" : charityOrganization.rawValue,
                                    "betting_amount" : bettingAmount,
                                    "is_top_challenge" : isTopChallenge
                                    ]
        
        let charityOrganizationUploadValues: [String : Any] =
                                            [
                                            "organization_name" : charityOrganizationName,
                                            "swish_number" : charityOrganizationSwishNumber,
                                            "logotype_image_path" : charityOrganizationLogotypeImagePath
                                            ]
    
        
        group.enter()
        
//        upload to challenge ref
        REF_SELF_CHALLENGES.child(self.challengeId).updateChildValues(challengeUploadValues) { (err, ref) in
            
            if let error = err {
                completion(.failure(error))
                return
            }
            
            let uploadValues2 = [self.challengeId:1]
            
//            upload challenge id to user ref
            REF_USERS.child(currentUserUid).child("challenges").child("self_challenges").child("active_challenges").updateChildValues(uploadValues2) { (err, ref) in
                
                if let error = err {
                    completion(.failure(error))
                    return
                }
                
                group.leave()
                
            }
        }
        
//        upload charity organization info if there is none already in the db
        group.notify(queue: .main) {
            REF_CHARITY_ORGANIZATIONS.child(charityOrganizationIdentifier).child("organization_info").updateChildValues(charityOrganizationUploadValues) { (err, ref) in
                
                if let error = err {
                    completion(.failure(error))
                    return
                }
            }
            
//            upload challenge id to charity org's active challenge ref
            REF_CHARITY_ORGANIZATIONS.child(charityOrganizationIdentifier).child("active_challenges").updateChildValues([self.challengeId : "1"]) { (err, ref) in
                
                if let error = err {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(true))
            }
        }
    }
    
    
}
//
//protocol PendingChallengeInterface {
//    var challengeId: UUID { get }
//    var challengeType: TypeOfChallenge { get }
//    var initializedByUserWithUid: String { get }
//    var challengedUserUid: String { get }
//    var duration: Duration { get }
//
//    func postPendingChallenge(_ challengeId: UUID, _ challengeType: TypeOfChallenge, _ initializedByUserWithUid: String, _ challengedUserUid: String, _ duration: Duration, completion: @escaping(Result<Bool, Error>) -> Void)
//
//
//
//    func activeChallenge(_ challengeId: UUID, _ challengeType: TypeOfChallenge, _ initializedByUserWithUid: String, _ acceptedByUserWithUid: String, _ startDate: Date, _ endDate: Date, _ duration: Duration) -> ActiveChallenge
//
//}
//
//protocol ActiveChallengeInterface {
//    var challengeId: UUID { get }
//    var challengeType: TypeOfChallenge { get }
//    var initializedByUserWithUid: String { get }
//    var acceptedByUserWithUid: String { get }
//    var startDate: Date { get }
//    var endDate: Date { get }
//    var duration: Duration { get }
//}
//
//struct PendingChallenge: PendingChallengeInterface {
//    func postPendingChallenge(_ challengeId: UUID, _ challengeType: TypeOfChallenge, _ initializedByUserWithUid: String, _ challengedUserUid: String, _ duration: Duration, completion: (Result<Bool, Error>) -> Void) {
//        completion(.success(true))
//    }
//
//    var challengedUserUid: String
//
//    let challengeId: UUID
//    let challengeType: TypeOfChallenge
//    let initializedByUserWithUid: String
//    let duration: Duration
//
//    func activeChallenge(_ challengeId: UUID, _ challengeType: TypeOfChallenge, _ initializedByUserWithUid: String, _ acceptedByUserWithUid: String, _ startDate: Date, _ endDate: Date, _ duration: Duration) -> ActiveChallenge {
//
////        do something to acquire accepted challenge
//
//        return ActiveChallenge(challengeId: challengeId,
//                                 challengeType: challengeType,
//                                 initializedByUserWithUid: initializedByUserWithUid,
//                                 acceptedByUserWithUid: acceptedByUserWithUid,
//                                 startDate: startDate,
//                                 endDate: endDate,
//                                 duration: duration)
//    }
//}
//
//struct ActiveChallenge: ActiveChallengeInterface {
//    let challengeId: UUID
//    let challengeType: TypeOfChallenge
//    let initializedByUserWithUid: String
//    let acceptedByUserWithUid: String
//    let startDate: Date
//    let endDate: Date
//    let duration: Duration
//
//
//}

//struct FinishedChallenge: ActiveChallengeInterface {
//    let challengeId: UUID
//    let challengeType: TypeOfChallenge
//    let initializedByUserWithUid: String
//    let acceptedByUserWithUid: String
//    let startDate: Date
//    let endDate: Date
//    let duration: Duration
//
//
//}

