//
//  MyDailyTasksViewController.swift
//  MyDailyTasks
//
//  Created by anita on 17.02.2022.
//

import UIKit

class MyDailyTasksViewController: UITableViewController, AddAndEditItemViewControllerDelegate {
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
    }
    
    func addAndEditItemViewController(_ controller: AddAndEditItemViewController, didFinishEditing item: MyDailyTasksItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    var items = [MyDailyTasksItem]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDailyTasksCell", for: indexPath)
        
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        return cell
 
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func configureText(for cell: UITableViewCell, with item: MyDailyTasksItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //deleting rows
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { [self] (contextualAction, view, actionPrformed: (Bool) -> Void) in
            
            performSegue(withIdentifier: "EditItem", sender: indexPath.row)
            actionPrformed(true)
        }
        
      
            return UISwipeActionsConfiguration(actions: [edit])
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

}
