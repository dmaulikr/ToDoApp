//
//  TaskViewController.swift
//  Crux
//
//  Created by Shanee Dinay on 7/11/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit
import os.log

class TaskViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var setTimer: UIDatePicker!
    
    var daySunday = false
    var dayMonday = false
    var dayTuesday = false
    var dayWednesday = false
    var dayThursday = false
    var dayFriday = false
    var daySaturday = false
    
    @IBOutlet weak var buttonSunday: UIButton!
    @IBOutlet weak var buttonMonday: UIButton!
    @IBOutlet weak var buttonTuesday: UIButton!
    @IBOutlet weak var buttonWednesday: UIButton!
    @IBOutlet weak var buttonThursday: UIButton!
    @IBOutlet weak var buttonFriday: UIButton!
    @IBOutlet weak var buttonSaturday: UIButton!
    
    let greenTrue = UIColor(red: 0, green: 153/255, blue: 0, alpha: 1)
    
    /*
     This value is either passed by `ToDoTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var task: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Handle the text field’s user input through delegate callbacks.
        taskNameTextField.delegate = self
        
        // If the task cell was tapped, fill in the task information
        // Set up views if editing an existing Meal.
        if let task = task {
            
            taskNameTextField.text = task.task
            
            let timerSeconds = task.duration
            setTimer.countDownDuration = TimeInterval(timerSeconds)
            
            if task.days[0] {
                buttonSunday.backgroundColor = greenTrue
                daySunday = true
            } else {
                daySunday = false
            }
            if task.days[1] {
                buttonMonday.backgroundColor = greenTrue
                dayMonday = true
            } else {
                dayMonday = false
            }
            if task.days[2] {
                buttonTuesday.backgroundColor = greenTrue
                dayTuesday = true
            } else {
                dayTuesday = false
            }
            if task.days[3] {
                buttonWednesday.backgroundColor = greenTrue
                dayWednesday = true
            } else {
                dayWednesday = false
            }
            if task.days[4] {
                buttonThursday.backgroundColor = greenTrue
                dayThursday = true
            } else {
                dayThursday = false
            }
            if task.days[5] {
                buttonFriday.backgroundColor = greenTrue
                dayFriday = true
            } else {
                dayFriday = false
            }
            if task.days[6] {
                buttonSaturday.backgroundColor = greenTrue
                daySaturday = true
            } else {
                daySaturday = false
            }
            
            // Load the Title of the Page
            navigationItem.title = task.task
            
        }
        
        // Enable the Save button only if the text field has a valid Task name.
        updateSaveButtonState()
    }

    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        /*let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        }*/
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let taskName = taskNameTextField.text ?? ""
        let taskDurationInSecs = setTimer.countDownDuration
        let taskFrequency = frequencyName()
        let taskDays = [daySunday, dayMonday, dayTuesday, dayWednesday, dayThursday, dayFriday, daySaturday]
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        task = ToDo(task: taskName, duration: Float(taskDurationInSecs), frequency: taskFrequency, days: taskDays)
    }
    
    //MARK: Days of the Week Buttons
    
    @IBAction func onClickSunday(_ sender: UIButton) {
        if daySunday {
            buttonSunday.backgroundColor = UIColor.darkGray
            daySunday = false
        } else {
            buttonSunday.backgroundColor = greenTrue
            daySunday = true
        }
    }
    
    @IBAction func onClickMonday(_ sender: UIButton) {
        if dayMonday {
            buttonMonday.backgroundColor = UIColor.darkGray
            dayMonday = false
        } else {
            buttonMonday.backgroundColor = greenTrue
            dayMonday = true
        }
    }
    
    @IBAction func onClickTuesday(_ sender: UIButton) {
        if dayTuesday {
            buttonTuesday.backgroundColor = UIColor.darkGray
            dayTuesday = false
        } else {
            buttonTuesday.backgroundColor = greenTrue
            dayTuesday = true
        }
    }
    
    @IBAction func onClickWednesday(_ sender: UIButton) {
        if dayWednesday {
            buttonWednesday.backgroundColor = UIColor.darkGray
            dayWednesday = false
        } else {
            buttonWednesday.backgroundColor = greenTrue
            dayWednesday = true
        }
    }
    
    @IBAction func onClickThursday(_ sender: UIButton) {
        if dayThursday {
            buttonThursday.backgroundColor = UIColor.darkGray
            dayThursday = false
        } else {
            buttonThursday.backgroundColor = greenTrue
            dayThursday = true
        }
    }
    
    @IBAction func onClickFriday(_ sender: UIButton) {
        if dayFriday {
            buttonFriday.backgroundColor = UIColor.darkGray
            dayFriday = false
        } else {
            buttonFriday.backgroundColor = greenTrue
            dayFriday = true
        }
    }
    
    @IBAction func onClickSaturday(_ sender: UIButton) {
        if daySaturday {
            buttonSaturday.backgroundColor = UIColor.darkGray
            daySaturday = false
        } else {
            buttonSaturday.backgroundColor = greenTrue
            daySaturday = true
        }
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = taskNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func frequencyName() -> String {
        
        let everyday = daySunday && dayMonday && dayTuesday && dayWednesday && dayThursday && dayFriday && daySaturday
        let weekdays = !daySunday && dayMonday && dayTuesday && dayWednesday && dayThursday && dayFriday && !daySaturday
        let weekends = daySunday && !dayMonday && !dayTuesday && !dayWednesday && !dayThursday && !dayFriday && !daySaturday
        let monwedfri = !daySunday && dayMonday && !dayTuesday && dayWednesday && !dayThursday && dayFriday && !daySaturday
        let tuesthurs = !daySunday && !dayMonday && dayTuesday && !dayWednesday && dayThursday && !dayFriday && !daySaturday
        let none = !daySunday && !dayMonday && !dayTuesday && !dayWednesday && !dayThursday && !dayFriday && !daySaturday
        
        if everyday {
            return "Everyday"
        } else if weekdays {
            return "Weekdays"
        } else if weekends {
            return "Weekends"
        }else if monwedfri {
            return "Mon Wed Fri"
        } else if tuesthurs {
            return "Tues Thurs"
        } else if none {
            return "Never"
        } else {
            var string = ""
            if daySunday { string += " Su" }
            if dayMonday { string += " M" }
            if dayTuesday { string += " T" }
            if dayWednesday { string += " W" }
            if dayThursday { string += " Th" }
            if dayFriday { string += " F" }
            if daySaturday { string += " Sa" }
            return string
        }
    }
    

}
