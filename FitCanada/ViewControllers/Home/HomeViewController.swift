//
//  HomeViewController.swift
//  FitCanada
//
//  Created by Vijin Raj on 12/09/24.
//

import Foundation
import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var workoutListCollectionView: UICollectionView!
    @IBOutlet weak var graphContainerView: BarGraphView!
    
    //Declarations
    let workoutListCellIdentifier = WorkoutListCollectionViewCell.identifier
    var bodyPartsData: [BodyPart] = []
    var workOutLogData: [WorkoutLog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchAndCacheBodyParts()
    }
    
    
}
//Local Functions
extension HomeViewController {
    
    func configureView(){
        registerCells()
    }
    
    func registerCells(){
        workoutListCollectionView.register(UINib(nibName: workoutListCellIdentifier, bundle: nil), forCellWithReuseIdentifier: workoutListCellIdentifier)
    }
}

//CoreData Helpers
extension HomeViewController{
    func fetchAndCacheBodyParts() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<BodyPart> = BodyPart.fetchRequest()

        do {
            let bodyParts = try context.fetch(fetchRequest)
            bodyPartsData = bodyParts // Save to local variable
            print("Fetched and cached \(bodyParts.count) body parts.")
            self.workoutListCollectionView.reloadData()
            self.fetchWorkoutLogsAscending()
        } catch {
            print("Failed to fetch body parts: \(error)")
        }
    }
    
    func fetchWorkoutLogsAscending(){
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<WorkoutLog> = WorkoutLog.fetchRequest()
        
        // Add a sort descriptor to sort by date in ascending order
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            // Fetch and return the sorted workout logs
            let workoutLogs = try context.fetch(fetchRequest)
            workOutLogData = workoutLogs
            self.configureBarGraph(_workOutData: workoutLogs)
        } catch {
            print("Failed to fetch workout logs: \(error)")
            
        }
    }
    
    func configureBarGraph(_workOutData:[WorkoutLog]){
        var sets : [Int32] = []
        var weight : [CGFloat] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        var day : [String] = []
        // Sort logs by date
        let sortedLogs = _workOutData.sorted {
            ($0.date ?? Date()) < ($1.date ?? Date())
        }
        let lastSevenLogs = sortedLogs.suffix(7)
        let lastSevenLogsArray = Array(lastSevenLogs)
        
        for log in lastSevenLogsArray {
            print("Sets: \(log.sets), Weight: \(log.weight), Date: \(log.date ?? Date())")
            sets.append(log.sets)
            weight.append(CGFloat(log.weight))
            if let date = log.date {
                let _day = dateFormatter.string(from: date)
                day.append(_day)
            }
        }
        
        print("Weight Array:\(weight)")
        // Set graph data
        graphContainerView.data = weight
        graphContainerView.labels = day
        graphContainerView.targetWeight = weight.first ?? 0
        
        // Refresh the view
        graphContainerView.setNeedsDisplay()
    }
}

//CollectionView Delegates
extension HomeViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bodyPartsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = workoutListCollectionView.dequeueReusableCell(withReuseIdentifier: workoutListCellIdentifier, for: indexPath) as! WorkoutListCollectionViewCell
        if self.bodyPartsData.count > 0{
            let cellData = bodyPartsData[indexPath.row]
            cell.cellData = cellData
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.bodyPartsData.count > 0{
            let cellData = bodyPartsData[indexPath.row]
            let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: WorkOutDetailsViewController.identifier) as! WorkOutDetailsViewController
            nextVC.bodyPartId = cellData.body_part_id
            nextVC.bodyPartName = cellData.name
            self.push(controller: nextVC)
        }
       
    }
    
}
