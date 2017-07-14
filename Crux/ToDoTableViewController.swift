//
//  ToDoTableViewController.swift
//  Crux
//
//  Created by Shanee Dinay on 7/8/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit
import os.log

class ToDoTableViewController: UITableViewController {

    //MARK: Properties
    
    var toDoList = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //cell.durationLabel.text = item.duration
        var plural = ""
        var time = "hour"
        var durationAltered = Float(0.0)
        // Display in Minutes
        if item.duration < 3600 {
            print("Item.duration = \(item.duration)")
            let durationInMins = item.duration / 60
            print("durationInMins = \(String(describing: durationInMins))")
            durationAltered = round(100 * durationInMins) / 100
            print("durationAltered = \(String(describing: durationAltered))")
            if( durationAltered != 1) {
                plural = "s"
            }
            time = "minute"
        } else {
            let durationInHours = item.duration / 3600
            durationAltered = round(1000 * durationInHours) / 1000
            if( durationAltered != 1) {
                plural = "s"
            }
        }
        cell.durationLabel.text = "for \(durationAltered) " + time + plural
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
            toDoList.remove(at: indexPath.row)
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
        if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            
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
            
        }
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
        print("Canceling action")
    }
    
    //MARK: Private Methods
    
    private func loadSampleToDoList() {
        let dayArray = [true, true, true, true, true, true, true]
        guard let item1 = ToDo(task: "Read", duration: 1800, frequency: "Everyday", days: dayArray) else {
            fatalError("Unable to instantiate item1")
        }
        
        guard let item2 = ToDo(task: "Run", duration: 7200, frequency: "Everyday", days: dayArray) else {
            fatalError("Unable to instantiate item2")
        }
        
        guard let item3 = ToDo(task: "Code Application", duration: 18000, frequency: "Weekdays", days: dayArray) else {
            fatalError("Unable to instantiate item3")
        }
        
        toDoList += [item1, item2, item3]
    }

}
