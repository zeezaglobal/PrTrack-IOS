//
//  WorkOutDetailsViewController.swift
//  FitCanada
//
//  Created by Vijin Raj on 30/11/24.
//

import Foundation
import UIKit
import CoreData

class WorkOutDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bodyPartNameLabel: UILabel!
    
    let cellIdentifier = WorkOutDetailsTableViewCell.identifier
    
    var fetchedWorkouts: [Workout] = []
    
    //set from parent
    var bodyPartId : UUID?
    var bodyPartName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getWorkOutList()
        populateUI()
    }
    
}
//Local Functions
extension WorkOutDetailsViewController{
    func configureView(){
        registerCells()
    }
    
    func populateUI(){
        self.bodyPartNameLabel.text = bodyPartName
    }
    
    func getWorkOutList(){
        if let _bodyPartId = self.bodyPartId{
            fetchWorkouts(bodyPartId: _bodyPartId)
        }
    }
    
    func configureTableViewHeight(){
        if self.fetchedWorkouts.count > 0{
            self.tableViewHeightConstraint.constant = CGFloat(self.fetchedWorkouts.count * 345)
        }
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
            let name = alertController.textFields?[0].text ?? ""
            print("Name: \(name)")
            if let _bodyPartId = self.bodyPartId{
                self.saveWorkout(name: name, desc: "", bodyPartId: _bodyPartId)
            }
            
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

//Coredata helper
extension WorkOutDetailsViewController{
    
    func fetchWorkouts(bodyPartId: UUID){
        let context = CoreDataManager.shared.context
        
        // Fetch the BodyPart using the body_part_id
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bodyPart.body_part_id == %@", bodyPartId as CVarArg)
        
        do {
            let workouts = try context.fetch(fetchRequest)
            self.fetchedWorkouts = workouts
            print("Fetched and cached \(workouts.count) workouts.")
            self.tableView.reloadData()
            self.configureTableViewHeight()
        } catch {
            print("Failed to fetch workouts for body part ID \(bodyPartId): \(error)")
        }
    }
    
    func saveWorkout(name: String, desc: String?, bodyPartId: UUID) {
        let context = CoreDataManager.shared.context
        
        // Fetch the BodyPart using the body_part_id
        let fetchRequest: NSFetchRequest<BodyPart> = BodyPart.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "body_part_id == %@", bodyPartId as CVarArg)
        
        do {
            // Fetch the BodyPart associated with the workout
            let bodyParts = try context.fetch(fetchRequest)
            
            if let bodyPart = bodyParts.first {
                // Create a new Workout
                let workout = Workout(context: context)
                workout.workout_id = UUID() // Assign a new workout ID
                workout.name = name
                workout.desc = desc
                workout.bodyPart = bodyPart // Set the relationship to BodyPart
                
                // Save the context to persist the workout
                CoreDataManager.shared.saveContext()
                print("Workout '\(name)' saved with body part \(bodyPart.name ?? "Unknown").")
                if let _bodyPartId = self.bodyPartId{
                    self.fetchWorkouts(bodyPartId: _bodyPartId)
                }
            } else {
                print("No BodyPart found with the given ID.")
            }
        } catch {
            print("Failed to save workout: \(error)")
        }
    }
    
    func saveWorkoutLog(workoutId: UUID, sets: Int, weight: Float) {
        let context = CoreDataManager.shared.context
        
        // Fetch the Workout entity using the workout_id
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "workout_id == %@", workoutId as CVarArg)
        
        do {
            let workouts = try context.fetch(fetchRequest)
            if let workout = workouts.first {
                // Create a new WorkoutLog entry
                let workoutLog = WorkoutLog(context: context)
                workoutLog.id = UUID() // Assign a new log ID
                workoutLog.sets = Int32(sets) // Assign the number of sets
                workoutLog.weight = Double(weight) // Assign the weight lifted
                workoutLog.workout = workout // Link the workout to the log
                workoutLog.date = Date()//Current date
                
                // Save the context to persist the workout log
                CoreDataManager.shared.saveContext()
                print("WorkoutLog saved for workout \(workout.name ?? "Unknown") with \(sets) sets and \(weight) kg weight.")
                if let _bodyPartId = self.bodyPartId{
                    self.fetchWorkouts(bodyPartId: _bodyPartId)
                }
            } else {
                print("Workout not found for the given workout_id.")
            }
        } catch {
            print("Failed to save workout log: \(error)")
        }
    }
}

//Table View Delegate
extension WorkOutDetailsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WorkOutDetailsTableViewCell
        cell.selectionStyle = .none
        if fetchedWorkouts.count > 0{
            let cellData = fetchedWorkouts[indexPath.row]
            cell.cellData = cellData
            cell.cellIndex = indexPath
            cell.delegate = self
        }
        
        return cell
    }
    
}
extension WorkOutDetailsViewController : WorkOutDetailsTableViewCellDelegate{
    func didSelectedAddWeight(cellIndex: IndexPath) {
        if self.fetchedWorkouts.count > 0{
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
                let weight = Float(alertController.textFields?[0].text ?? "0")
                let reps = Int(alertController.textFields?[1].text ?? "0")
                print("Weight: \(weight ?? 0)")
                print("Reps: \(reps ?? 0)")
                if let _workOutId = self.fetchedWorkouts[cellIndex.row].workout_id{
                    self.saveWorkoutLog(workoutId: _workOutId, sets: reps ?? 0, weight: weight ?? 0)
                }
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
    
    
}
