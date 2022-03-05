//
//  AddAndEditItemViewController.swift
//  MyDailyTasks
//
//  Created by anita on 17.02.2022.
//

import UIKit
import UserNotifications

protocol AddAndEditItemViewControllerDelegate: AnyObject {
    
    func addAndEditItemViewControllerDidCancel(_ controller: AddAndEditItemViewController)
    func addAndEditItemViewController(_ controller: AddAndEditItemViewController, didFinishAdiing item: MyDailyTasksItem)
    func addAndEditItemViewController(_ controller: AddAndEditItemViewController, didFinishEditing item: MyDailyTasksItem)
}

class AddAndEditItemViewController: UITableViewController, UITextFieldDelegate{

    weak var delegate: AddAndEditItemViewControllerDelegate?
    var itemToEdit: MyDailyTasksItem?
    let skyBlueColor = UIColor(red: 242/255, green: 247/255, blue: 255/255, alpha: 1)
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var switchOn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.tableView.backgroundColor = skyBlueColor
        if let item = itemToEdit {
             title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            switchOn.isOn = item.shouldRemind
            datePicker.date = item.date
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear

    }
    // MARK: - Actions

    @IBAction func cancel() {
        delegate?.addAndEditItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = switchOn.isOn
            item.date = datePicker.date
            item.scheduleNotification()
            delegate?.addAndEditItemViewController(self, didFinishEditing: item)
        } else {
            let item = MyDailyTasksItem()
            item.text = textField.text!
            item.shouldRemind = switchOn.isOn
            item.date = datePicker.date
            item.scheduleNotification()
            delegate?.addAndEditItemViewController(self, didFinishAdiing: item)
        }
    }
    
    @IBAction func shouldRemindIsOn(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {_, _ in })
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
        return true
    }
    
    
}
