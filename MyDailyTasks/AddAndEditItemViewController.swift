//
//  AddAndEditItemViewController.swift
//  MyDailyTasks
//
//  Created by anita on 17.02.2022.
//

import UIKit

protocol AddAndEditItemViewControllerDelegate: AnyObject {
    
    func addAndEditItemViewControllerDidCancel(_ controller: AddAndEditItemViewController)
    
    func addAndEditItemViewController(_ controller: AddAndEditItemViewController, didFinishAdiing item: MyDailyTasksItem)
    func addAndEditItemViewController(_ controller: AddAndEditItemViewController, didFinishEditing item: MyDailyTasksItem)
    
}

class AddAndEditItemViewController: UITableViewController, UITextFieldDelegate {

    weak var delegate: AddAndEditItemViewControllerDelegate?
    
    var itemToEdit: MyDailyTasksItem?
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
             title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        
       
    }
    // MARK: - Table view data source

    @IBAction func cancel() {
        delegate?.addAndEditItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!
            item.date = datePicker.date
            delegate?.addAndEditItemViewController(self, didFinishEditing: item)
            
        } else {
        
            let item = MyDailyTasksItem()
            item.text = textField.text!
            item.date = datePicker.date
            delegate?.addAndEditItemViewController(self, didFinishAdiing: item)
            
        
    }
    }
    
    //MARK: Table View Delegates
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK: - Text Field Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        datePicker.isEnabled = false
        
        return true
    }
}
