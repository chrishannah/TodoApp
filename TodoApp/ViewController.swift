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

    let realm = try! Realm()
    var tasks: Results<TaskItem> {
        get {
            return realm.objects(TaskItem.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel!.text = task.text
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
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        try! self.realm.write {
            task.status = !task.status
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let task = tasks[indexPath.row]
            try! self.realm.write({
                self.realm.delete(task)
            })
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: Interface Actions
    
    @IBAction func newPressed(_ sender: Any) {
        let task = TaskItem()
        task.text = "Example Task!"
        task.priority = 2
        
        try! self.realm.write({
            self.realm.add(task)
            self.tableView.insertRows(at: [IndexPath.init(row: self.tasks.count-1, section: 0)], with: .automatic)
        })
        
    }

}

