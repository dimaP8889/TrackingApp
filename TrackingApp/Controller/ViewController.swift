//
//  ViewController.swift
//  TrackingApp
//
//  Created by dmitriy1 on 03.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import UIKit
import CoreMotion
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    var userData = UserData()
    
    @IBOutlet weak var StepsCounter: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDate()
        
        userData.getData()
        
        if let steps = defaults.value(forKey: "NumberofSteps") as? Int {
            
            userData.LastSessionSteps = steps
            StepsCounter.text = "\(userData.LastSessionSteps)"
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(getDate), name:.NSCalendarDayChanged, object:nil) // set NotificationCenter to send data to server each day
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateLabel), userInfo: nil, repeats: true) // set timer to update label
    }
    
    //MARK: - get today data
    @objc func getDate() {
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let dateNow = "\(year) \(month) \(day)"
        
        let userStepsDB = Database.database().reference().child("Steps")
        
        let stepsDictionaryDB = [dateNow : userData.NumberOfSteps + userData.LastSessionSteps]
        
        userStepsDB.childByAutoId().setValue(stepsDictionaryDB)
        
        nullData()
    }
    
    //MARK: - After sending data do server, set steps to 0
    func nullData() {
        
        userData.NumberOfSteps = 0
        userData.LastSessionSteps = 0
        
        userData.pedometer.stopUpdates()
        
        defaults.removePersistentDomain(forName: "NumberofSteps")
        defaults.synchronize()
        
        userData.getData()
    }
    
    //MARK: - Update Label set on timer
    @objc func updateLabel() {
        
        if CMPedometer.isStepCountingAvailable() {
            
            StepsCounter.text = "\(userData.NumberOfSteps  + userData.LastSessionSteps)"
            
            self.defaults.set(self.userData.NumberOfSteps + self.userData.LastSessionSteps, forKey: "NumberofSteps")

        }
    }
}

