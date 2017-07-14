//
//  ToDo.swift
//  Crux
//
//  Created by Shanee Dinay on 7/8/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit

class ToDo: NSObject {
    
    //MARK: Properties
    
    var task: String
    var duration: Float
    var frequency: String
    var days: [Bool]
    
    //MARK: Initialization
    
    init?(task: String, duration: Float, frequency: String, days: [Bool]) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if task.isEmpty || duration < 0  {
            return nil
        }
        
        if duration < 0 {
            return nil
        }
        
        // Initialize stored properties.
        self.task = task
        self.duration = duration
        self.frequency = frequency
        self.days = days
    }
    
}
