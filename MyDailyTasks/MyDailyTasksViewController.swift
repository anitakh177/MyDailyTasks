//
//  MyDailyTasksViewController.swift
//  MyDailyTasks
//
//  Created by anita on 17.02.2022.
//

import UIKit
import UserNotifications


class MyDailyTasksViewController: UITableViewController, AddAndEditItemViewControllerDelegate {
    
    var items = [MyDailyTasksItem]()
    let skyBlueColor = UIColor(red: 242/255, green: 247/255, blue: 255/255, alpha: 1)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = skyBlueColor
        navigationController?.navigationBar.prefersLargeTitles = true
        loadMyDailyTasksItem()
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDailyTasksCell", for: indexPath)
        
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        let date = items[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
//MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveMyDaileTasksItem()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { [self]
            (contextualAction, view, actionPerformed: (Bool) -> Void) in
            
            performSegue(withIdentifier: "EditItem", sender: indexPath.row)
            actionPerformed(true)
        }
    
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self]
            (contextualAction, view, actionPerformed: (Bool) -> Void) in
            self?.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            actionPerformed(true)
                                                                                    
        }
            edit.backgroundColor = .systemBlue
            delete.image = UIImage(systemName: "trash")
            delete.backgroundColor = .systemRed
        
            saveMyDaileTasksItem()
        
            return UISwipeActionsConfiguration(actions: [edit, delete])
        }
    
    //MARK: - Configuration
    
    func configureText(for cell: UITableViewCell, with item: MyDailyTasksItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
       
    }
    
    /*func configureDate(for cell: UITableViewCell, with item: MyDailyTasksItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = item.date
        
        
        
    } */
    
    func configureCheckmark(for cell: UITableViewCell, with item: MyDailyTasksItem) {
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    
//MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddAndEditItemViewController
            controller.delegate = self
                    }
       
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddAndEditItemViewController
            controller.delegate = self
            
            let index = sender as! Int
            controller.itemToEdit = items[index]
           }
    }
    
    //MARK: - Add Item View Controller Delegates
    
    func addAndEditItemViewControllerDidCancel(_ controller: AddAndEditItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addAndEditItemViewController(_ controller: AddAndEditItemViewController, didFinishAdiing item: MyDailyTasksItem) {
        
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveMyDaileTasksItem()
    }
    
    func addAndEditItemViewController(_ controller: AddAndEditItemViewController, didFinishEditing item: MyDailyTasksItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
            
        }
        navigationController?.popViewController(animated: true)
        saveMyDaileTasksItem()
    }
    
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
