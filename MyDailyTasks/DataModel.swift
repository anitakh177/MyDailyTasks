//
//  DataModel.swift
//  MyDailyTasks
//
//  Created by anita on 04.03.2022.
//

import Foundation

class DataModel {
    var items = [MyDailyTasksItem]()
    
    //MARK: Save and load data
    
    func documentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("MyDailyTasks.plist")
    }
    
    func saveMyDaileTasksItem() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encodig item array: \(error.localizedDescription)")
        }
    }
    
    func loadMyDailyTasksItem() {
        
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([MyDailyTasksItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }

}
