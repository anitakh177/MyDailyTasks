//
//  MyDailyTasksModel.swift
//  MyDailyTasks
//
//  Created by anita on 17.02.2022.
//

import UIKit
import UserNotifications

class MyDailyTasksItem: NSObject, Codable  {
    
    var text = ""
    var checked = false
    var date = Date()
    var shouldRemind = false
    var uuidString = UUID().uuidString
  
    deinit {
        removeNotification()
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && date > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
           
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [uuidString])
        
    }
}
