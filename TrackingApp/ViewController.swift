//
//  ViewController.swift
//  TrackingApp
//
//  Created by dmitriy1 on 03.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import UIKit
import CoreMotion
import SpriteKit

class ViewController: UIViewController {

    var userData = UserData()
    
    var timer = Timer()
    
    @IBOutlet weak var StepsCounter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData.getData()
        StepsCounter.text = "\(userData.NumberOfSteps)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabel() {
        
        if CMPedometer.isStepCountingAvailable() {
            
            StepsCounter.text = "\(userData.NumberOfSteps)"
        }
    }
}

