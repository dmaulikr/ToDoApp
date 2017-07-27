//
//  ToDoTableViewController.swift
//  Crux
//
//  Created by Shanee Dinay on 7/8/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseAuth

class ToDoTableViewController: UITableViewController {

    //MARK: Properties
    
    var toDoList = [ToDo]()
    
    let UserRef = Database.database().reference(withPath: "users")
    let TaskRef = Database.database().reference(withPath: "tasks")
    let userIdString : String = (Auth.auth().currentUser?.uid)!
    var CurrentUser: User!

    //MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ToDoTableViewController: View Did Load")
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        loadSampleToDoList()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // makes the table view show 1 section instead of 0
        return 1 // Changed from 0 to 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ToDoTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ToDoTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ToDoTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let item = toDoList[indexPath.row]
        
        cell.taskLabel.text = item.task
        cell.durationLabel.text = durationString(seconds: Int(item.duration))
        //cell.durationLabel.text = "for \(durationAltered) " + time + plural
        cell.frequencyLabel.text = item.frequency
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let removeTask = toDoList.remove(at: indexPath.row)
            
            print("Removed task key = \(removeTask.key)")
            // Delete the task from the Firebase Database
            TaskRef.child(removeTask.key).removeValue()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "AddTask":
                os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            case "ShowTaskDetail":
                guard let taskDetailViewController = segue.destination as? TaskViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
            
                guard let selectedToDoCell = sender as? ToDoTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedToDoCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
            
                let selectedTask = toDoList[indexPath.row]
                taskDetailViewController.task = selectedTask
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
    }
 
    
    //MARK: Actions
    
    @IBAction func unwindToToDoList(sender: UIStoryboardSegue) {
        print("Unwinding task after save")
        if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing task.
                toDoList[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                print("Old task was updated")
                
                // Update a task from Firebase Database
                let updateTaskRef = TaskRef.child(task.key)
                let updateTaskInfo = [
                    "task": task.task,
                    "duration": task.duration,
                    "frequency": task.frequency,
                    "days": task.days,
                    "user": task.user
                    ] as [String : AnyObject]
                updateTaskRef.setValue(updateTaskInfo)
            } else {
                print("Unwind: New task was created with name: \(task.task)")
                // Add a new Task.
                let newIndexPath = IndexPath(row: toDoList.count, section: 0)
                toDoList.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                // Add a new task to Firebase Database
                let newTaskRef = TaskRef.child(task.key)
                let newTaskInfo = [
                                   "task": task.task,
                                   "duration": task.duration,
                                   "frequency": task.frequency,
                                   "days": task.days,
                                   "user": task.user
                                  ] as [String : AnyObject]
                newTaskRef.setValue(newTaskInfo)
            }
        }
        //self.tableView.reloadData()
    }
    
    @IBAction func unwindToToDoListCancel(sender: UIStoryboardSegue) {
        /*if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing task.
                toDoList[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new rask.
                let newIndexPath = IndexPath(row: toDoList.count, section: 0)
                
                toDoList.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }*/
        print("Canceling add task action")
    }
    
    //MARK: Private Methods
    
    private func loadSampleToDoList() {
        print("loadSampleToDoList: Load Sample To Do List begin")
        
        UserRef.child(userIdString).observe(.value, with: {snapshot in
            let taskList = (snapshot.value as! NSDictionary)["tasklist"] as! Array<String>
            for taskKey in taskList {
                self.TaskRef.child(taskKey).observe(.value, with: { snapshot in
                    
                    // If the task does not belong to the user, skip it
                    let user = (snapshot.value as! NSDictionary)["user"] as! String
                    if user != self.userIdString {
                        print("User task list contains incorrect tasks: \(taskKey)")
                    }
                    
                    let task = (snapshot.value as! NSDictionary)["task"] as! String
                    let duration = (snapshot.value as! NSDictionary)["duration"] as! Float
                    let frequency = (snapshot.value as! NSDictionary)["frequency"] as! String
                    let days = (snapshot.value as! NSDictionary)["days"] as! Array<Bool>
                    
                    // Check that the ToDo object with the key DNE in the toDoList Array
                    if self.toDoList.isEmpty {
                        guard let item = ToDo(task: task, duration: duration, frequency: frequency, days: days, user: self.userIdString, key: taskKey) else {
                            fatalError("Unable to instantiate item")
                        }
                        print("loadSampleToDoList - observe: New task was created with name: \(task) and key: \(taskKey)")
                        let newIndexPath = IndexPath(row: self.toDoList.count, section: 0)
                        self.toDoList.append(item)
                        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                    }
                    
                    var newTask = false
                    for j in self.toDoList {
                        if j.key == taskKey {
                            print("Duplicate ToDo")
                            newTask = false
                            break
                        } else {
                            newTask = true
                        }
                    }
                    if newTask {
                        guard let item = ToDo(task: task, duration: duration, frequency: frequency, days: days, user: self.userIdString, key: taskKey) else {
                            fatalError("Unable to instantiate item")
                        }
                        print("loadSampleToDoList - observe: New task was created with name: \(task) and key: \(taskKey)")
                        let newIndexPath = IndexPath(row: self.toDoList.count, section: 0)
                        self.toDoList.append(item)
                        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                    }
                    
                })
            }
        })
        print("loadSampleToDoList: Load Sample To Do List ended")
    }
    
    func stringArrayToArray(days: String) -> Array<Bool> {
        var daysTrimmed = days.replacingOccurrences(of: "[", with: "")
        daysTrimmed = daysTrimmed.replacingOccurrences(of: "]", with: "")
        let daysArray = daysTrimmed.components(separatedBy: ", ")
        var finalArray = [Bool]()
        if days != "" {
            for i in 0 ..< 7 {
                if daysArray[i] == "true" {
                    finalArray.append(true)
                } else {
                    finalArray.append(false)
                }
            }
            return finalArray
        } else {
            print("CError: days Array is empty: \(days)")
            return finalArray
        }
    }
    
    func durationString(seconds: Int) -> String {
        
        let hours = Int(seconds / 3600)
        let remainderOfHours = seconds % 3600
        let minutes = Int(remainderOfHours / 60)
        
        var hoursS = "\(hours)"
        if hours == 0 {
            hoursS = ""
        }
        
        var minutesS = "\(minutes)"
        if minutes == 0 {
            minutesS = ""
        }
        
        var pluralHours = ""
        if hours != 1 && hours != 0 {
            pluralHours = "s"
        }
        var pluralMinutes = ""
        if minutes != 1 && minutes != 0 {
            pluralMinutes = "s"
        }
        
        var stringHours = " hour"
        if hours == 0 {
            stringHours = ""
        }
        
        var stringMinutes = " min"
        if minutes == 0 {
            stringMinutes = ""
        }
        
        var and = ""
        if hours > 0 && minutes > 0 {
            and = " and "
        }
        
        return "for " + hoursS + stringHours + pluralHours + and + minutesS + stringMinutes + pluralMinutes
    }

}
