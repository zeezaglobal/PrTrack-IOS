//
//  HomeViewController.swift
//  FitCanada
//
//  Created by Vijin Raj on 12/09/24.
//

import Foundation
import UIKit
class HomeViewController: UIViewController {
    
    @IBOutlet weak var workoutListCollectionView: UICollectionView!
    @IBOutlet weak var graphContainerView: BarGraphView!
    
    //Declarations
    let workoutListCellIdentifier = WorkoutListCollectionViewCell.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    
}
//Local Functions
extension HomeViewController {
    
    func configureView(){
        registerCells()
        configureBarGraph()
    }
    
    func registerCells(){
        workoutListCollectionView.register(UINib(nibName: workoutListCellIdentifier, bundle: nil), forCellWithReuseIdentifier: workoutListCellIdentifier)
    }
    
    func configureBarGraph(){
        // Set graph data
        graphContainerView.data = [10, 40, 50, 60, 55, 70, 65]
        graphContainerView.labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        graphContainerView.targetWeight = 60
        
        // Refresh the view
        graphContainerView.setNeedsDisplay()
    }
}

//CollectionView Delegates
extension HomeViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = workoutListCollectionView.dequeueReusableCell(withReuseIdentifier: workoutListCellIdentifier, for: indexPath) as! WorkoutListCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: WorkOutDetailsViewController.identifier) as! WorkOutDetailsViewController
        self.push(controller: nextVC)
    }
    
}
