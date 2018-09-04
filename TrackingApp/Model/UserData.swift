//
//  File.swift
//  TrackingApp
//
//  Created by dmitriy1 on 03.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import Foundation
import CoreMotion

class UserData {
    
    let pedometer = CMPedometer()
    
    var NumberOfSteps = 0
    
    var LastSessionSteps = 0
    
    let defaults = UserDefaults.standard

    
    func getData() {
        
        pedometer.startUpdates(from: Date()) {
            pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                self.NumberOfSteps = pedometerData.numberOfSteps.intValue
                self.defaults.set(self.NumberOfSteps + self.LastSessionSteps, forKey: "NumberofSteps")
            }
        }
    }
}
