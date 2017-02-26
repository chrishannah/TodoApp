//
//  TaskItem.swift
//  TodoApp
//
//  Created by Christopher Hannah on 26/02/2017.
//  Copyright © 2017 Christopher Hannah. All rights reserved.
//

import Foundation
import RealmSwift

class TaskItem: Object {
    dynamic var text = ""
    dynamic var priority = 0
    dynamic var status = false
    dynamic var date:NSDate = NSDate()
}
