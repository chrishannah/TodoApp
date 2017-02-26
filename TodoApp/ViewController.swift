//
//  ViewController.swift
//  TodoApp
//
//  Created by Christopher Hannah on 26/02/2017.
//  Copyright © 2017 Christopher Hannah. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // Sort/Filter enum
    enum SortType: String {
        case date = "date"
        case priority = "priority"
        case name = "text"
    }
    
    enum SortDirection {
        case asc
        case desc
    }
    
    enum FilterComplete {
        case all
        case incomplete
        case complete
    }
    
    // Sort/Filter UI
    @IBOutlet weak var sortBySegmentControl: UISegmentedControl!
    @IBOutlet weak var sortByDirectionSegmentControl: UISegmentedControl!
    @IBOutlet weak var sortSectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterPrioritySegmentControl: UISegmentedControl!
    @IBOutlet weak var filterCompleteSegmentControl: UISegmentedControl!
    
    // Sort/Filter Variables
    var sortType = SortType.date
    var sortDirection = SortDirection.asc
    var filterComplete = FilterComplete.all

    var realm = try! Realm()
    var tasks: Results<TaskItem> {
        get {
            // All Objects
            var objects = realm.objects(TaskItem.self)
            
            // Add Completion Filter
            if (filterComplete == .complete) {
                objects = objects.filter("status = true")
            } else if (filterComplete == .incomplete) {
                objects = objects.filter("status != true")
            }
            
            // Add Sorting
            var ascending = false
            if sortDirection == .asc {
                ascending = true
            }
            objects = objects.sorted(byKeyPath: sortType.rawValue, ascending: ascending)
            
            return objects
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        
        // Title
        cell.textLabel!.text = task.text
        
        // Date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let date = formatter.string(from: task.date as Date)
        
        // Priority
        var priority = ""
        switch (task.priority) {
        case 0:
            priority = "Low"
            break
        case 1:
            priority = "Medium"
            break
        case 2:
            priority = "High"
            break
        default:
            priority = "Low"
            break
        }
        
        // Set Description Label
        let descriptionText = "PRIORITY: \(priority)  DATE: \(date)".uppercased()
        cell.detailTextLabel!.text = descriptionText
        
        // Completion Status
        if task.status {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let titles = ["Edit", "Delete"]
        return titles[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Edit Action
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let task = self.tasks[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addTaskVC = storyboard.instantiateViewController(withIdentifier: "addTaskViewController") as! AddTaskViewController
            addTaskVC.isEditingTask = true
            addTaskVC.task = task
            self.present(addTaskVC, animated: true, completion: nil)
           
        })
        editAction.backgroundColor = UIColor.lightGray
        
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let task = self.tasks[indexPath.row]
            try! self.realm.write({
                self.realm.delete(task)
            })
            self.tableView.reloadData()

        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        try! self.realm.write {
            task.status = !task.status
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Interface Actions
    
    @IBAction func sortByChanged(_ sender: UISegmentedControl) {
        switch (sortBySegmentControl.selectedSegmentIndex) {
        case 0:
            sortType = .date
            break
        case 1:
            sortType = .priority
            break
        case 2:
            sortType = .name
            break
        default:
            sortType = .date
            break
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sortByDirectionChanged(_ sender: UISegmentedControl) {
        if sortByDirectionSegmentControl.selectedSegmentIndex == 0 {
            sortDirection = .asc
        } else {
            sortDirection = .desc
        }
        self.tableView.reloadData()
    }
    
    @IBAction func toggleSort(_ sender: Any) {
        if let constraint = sortSectionConstraint {
            if constraint.constant == 30 {
                sortSectionConstraint.constant = 210
            } else {
                sortSectionConstraint.constant = 30
            }
        }
        
    }
    
    @IBAction func filterPriorityChanged(_ sender: Any) {
    }

    @IBAction func filterCompleteChanged(_ sender: Any) {
        switch filterCompleteSegmentControl.selectedSegmentIndex {
        case 0:
            filterComplete = .all
            break
        case 1:
            filterComplete = .incomplete
            break
        case 2:
            filterComplete = .complete
            break
        default:
            filterComplete = .all
            break
        }
        self.tableView.reloadData()
    }

}

