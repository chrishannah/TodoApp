//
//  AddTaskViewController.swift
//  TodoApp
//
//  Created by Christopher Hannah on 26/02/2017.
//  Copyright © 2017 Christopher Hannah. All rights reserved.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var realm = try! Realm()
    
    var isEditingTask = false
    var task: TaskItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditingTask {
            print("Editing")
            if task != nil {
                taskTextField.text = task?.text
                datePicker.setDate(task?.date as! Date, animated: true)
                prioritySegmentControl.selectedSegmentIndex = (task?.priority)!
                addTaskButton.setTitle("Save Task", for: .normal)
                navigationBar.topItem?.title = "Edit Task"
            }
        } else {
            addTaskButton.titleLabel?.text = "Add Task"
            navigationBar.topItem?.title = "Add Task"
        }
    }

    @IBAction func addTaskPressed(_ sender: Any) {
        if isEditingTask {
            try! self.realm.write({
                self.realm.delete(task!)
            })
        }
        let newTask = TaskItem()
        
        if (!(taskTextField.text?.isEmpty)!) {
            newTask.text = taskTextField.text!
        } else {
            newTask.text = "Blank Task"
        }
        
        newTask.date = datePicker.date as NSDate
        
        newTask.priority = prioritySegmentControl.selectedSegmentIndex
        
        
        try! self.realm.write({
            self.realm.add(newTask)
        })
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
