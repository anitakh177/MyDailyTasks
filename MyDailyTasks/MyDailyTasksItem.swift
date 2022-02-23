//
//  MyDailyTasksModel.swift
//  MyDailyTasks
//
//  Created by anita on 17.02.2022.
//

import UIKit

class MyDailyTasksItem: NSObject, Codable {
    
    var text = ""
    var checked = false
    var date = Date()
}
