//
//  WorkOutDetailsViewController.swift
//  FitCanada
//
//  Created by Vijin Raj on 30/11/24.
//

import Foundation
import UIKit

class WorkOutDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    let cellIdentifier = WorkOutDetailsTableViewCell.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}
//Local Functions
extension WorkOutDetailsViewController{
    func configureView(){
        registerCells()
        configureTableViewHeight()
    }
    
    func configureTableViewHeight(){
        self.tableViewHeightConstraint.constant = 3 * 345
    }
    
    
    func registerCells(){
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
}
//Button Action
extension WorkOutDetailsViewController{
    @IBAction func backButtonAction(_sender: UIButton) {
        self.pop()
    }
    @IBAction func addWorkOutButtonAction(_sender: UIButton) {
        let alertController = UIAlertController(title: "Add New Workout", message: "Please enter the workout name", preferredStyle: .alert)

        // Add the first text field for weight
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.keyboardType = .default
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Add the Save action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let weight = alertController.textFields?[0].text
            print("Name: \(weight ?? "None")")
        }

        // Initially disable the Save button
        saveAction.isEnabled = false

        // Add a target to monitor text field changes
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: OperationQueue.main) { _ in
            let nameText = alertController.textFields?[0].text ?? ""
            
            // Enable the Save button only if both fields are not empty
            saveAction.isEnabled = !nameText.trimmingCharacters(in: .whitespaces).isEmpty
        }

        // Add actions to the alert controller
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
}
//Table View Delegate
extension WorkOutDetailsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WorkOutDetailsTableViewCell
        cell.selectionStyle = .none
        cell.cellIndex = indexPath
        cell.delegate = self
        return cell
    }
    
}
extension WorkOutDetailsViewController : WorkOutDetailsTableViewCellDelegate{
    func didSelectedAddWeight(cellIndex: IndexPath) {
        let alertController = UIAlertController(title: "Add Weight", message: "Please enter the weight lifted", preferredStyle: .alert)

        // Add the first text field for weight
        alertController.addTextField { (textField) in
            textField.placeholder = "Weight"
            textField.keyboardType = .decimalPad // Optional: Set the keyboard type
        }

        // Add the second text field for reps
        alertController.addTextField { (textField) in
            textField.placeholder = "Reps"
            textField.keyboardType = .numberPad // Optional: Set the keyboard type
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Add the Save action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let weight = alertController.textFields?[0].text
            let reps = alertController.textFields?[1].text
            print("Weight: \(weight ?? "None")")
            print("Reps: \(reps ?? "None")")
        }

        // Initially disable the Save button
        saveAction.isEnabled = false

        // Add a target to monitor text field changes
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: OperationQueue.main) { _ in
            let weightText = alertController.textFields?[0].text ?? ""
            let repsText = alertController.textFields?[1].text ?? ""
            
            // Enable the Save button only if both fields are not empty
            saveAction.isEnabled = !weightText.trimmingCharacters(in: .whitespaces).isEmpty &&
                                   !repsText.trimmingCharacters(in: .whitespaces).isEmpty
        }

        // Add actions to the alert controller
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
}
