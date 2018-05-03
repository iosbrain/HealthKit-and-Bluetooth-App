//
//  HealthKitGenderInterface.swift
//  Core Bluetooth HRM
//
//  Created by Andrew L. Jaffee on 4/13/18.
//
/*
 
 Copyright (c) 2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

import Foundation

// STEP 1: MUST import HealthKit
import HealthKit

class HealthKitGenderInterface
{
    
    // STEP 2: a placeholder for a conduit to all HealthKit data
    let healthKitDataStore: HKHealthStore?
    
    // STEP 3: get a user's physical property that won't change
    let genderCharacteristic = HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
    
    // STEP 4: for flexibility, the API allows us to ask for
    // multiple characteristics at once
    let readableHKCharacteristicTypes: Set<HKCharacteristicType>?
    
    init() {
        
        // STEP 5: make sure HealthKit is available
        if HKHealthStore.isHealthDataAvailable() {
            
            // STEP 6: create one instance of the HealthKit store
            // per app; it's the conduit to all HealthKit data
            self.healthKitDataStore = HKHealthStore()
            
            // STEP 7: I create a Set of one as that's what the call wants
            readableHKCharacteristicTypes = [genderCharacteristic!]
            
            // STEP 8: request user permission to read gender and
            // then read the value asynchronously
            healthKitDataStore?.requestAuthorization(toShare: nil,
                                                     read: readableHKCharacteristicTypes,
                                                          completion: { (success, error) -> Void in
                                                            if success {
                                                                print("Successful authorization.")
                                                                // STEP 9.1: read gender data (see below)
                                                                self.readGenderType()
                                                            } else {
                                                                print(error.debugDescription)
                                                            }
                                                    })
            
        } // end if HKHealthStore.isHealthDataAvailable()
            
        else {
            
            self.healthKitDataStore = nil
            readableHKCharacteristicTypes = nil
            
        }
        
    } // end init()
    
    // STEP 9.2: actual code to read gender data
    func readGenderType() -> Void {
        
        do {
            
            let genderType = try self.healthKitDataStore?.biologicalSex()
            
            if genderType?.biologicalSex == .female {
                print("Gender is female.")
            }
            else if genderType?.biologicalSex == .male {
                print("Gender is male.")
            }
            else {
                print("Gender is unspecified.")
            }
            
        }
        catch {
            print("Error looking up gender.")
        }
        
    } // end func readGenderType
    
} // end class HealthKitGenderInterface
