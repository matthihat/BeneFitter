//
//  HealthKitAssistans.swift
//  BeneFitter
//
//  Created by Mattias Törnqvist on 2020-07-09.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation
import HealthKit

struct HealthKitAssistant {
    
//    Create error types that can be thrown
    private enum HealthkitSetupError: Error {
      case notAvailableOnDevice
      case dataTypeNotAvailable
    }
    
    static func authorizeHealthKit(completion: @escaping(Result<Bool, Error>) -> Swift.Void) {
        
//1. Check to see if HealthKit Is Available on this device
    guard HKHealthStore.isHealthDataAvailable() else {
        completion(.failure(HealthkitSetupError.notAvailableOnDevice))
      return
    }
    
//2. Prepare the data types that will interact with HealthKit
    guard
//        let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
//            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
//            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
//            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
//            let height = HKObjectType.quantityType(forIdentifier: .height),
//            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        else {
            completion(.failure(HealthkitSetupError.dataTypeNotAvailable))
            return
        }
    
//3. Prepare a list of types you want HealthKit to read and write
    let healthKitTypesToRead: Set<HKObjectType> = [
//                                                    dateOfBirth,
//                                                   bloodType,
//                                                   biologicalSex,
//                                                   bodyMassIndex,
//                                                   height,
                                                   activeEnergy,
//                                                   bodyMass,
                                                   stepCount,
                                                   HKObjectType.workoutType()]
    
//4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, err) in
            
            if let error = err {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
    }
        
    }

}

