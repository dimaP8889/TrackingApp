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
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.getDate), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateLabel), userInfo: nil, repeats: true)
    }
    
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
        
        userData.NumberOfSteps = 0
        userData.LastSessionSteps = 0
        self.defaults.set(0, forKey: "NumberofSteps")
    }
    
    @objc func updateLabel() {
        
        if CMPedometer.isStepCountingAvailable() {
            
            StepsCounter.text = "\(userData.NumberOfSteps  + userData.LastSessionSteps)"
        }
    }
}

