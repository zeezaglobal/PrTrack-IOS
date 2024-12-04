//
//  WorkOutDetailsTableViewCell.swift
//  FitCanada
//
//  Created by Vijin Raj on 30/11/24.
//

import UIKit
protocol WorkOutDetailsTableViewCellDelegate: AnyObject {
    func didSelectedAddWeight(cellIndex:IndexPath)
}
class WorkOutDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var graphContainerView: BarGraphView!
    @IBOutlet weak var workOutNameLabel : UILabel!
    @IBOutlet weak var lastLiftLabel : UILabel!
    
    //set from parent
    weak var delegate : WorkOutDetailsTableViewCellDelegate?
    var cellIndex: IndexPath?
    //Set from parent
    var cellData:Workout?{
        didSet{
            self.populateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//Local Functions
extension WorkOutDetailsTableViewCell{
    func configureBarGraph(_cellData:Workout){
        var sets : [Int32] = []
        var weight : [CGFloat] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        var day : [String] = []
        if let workoutLogs = _cellData.workoutLogs as? Set<WorkoutLog> {
            // Sort logs by date
            let sortedLogs = workoutLogs.sorted {
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
        }
        print("Weight Array:\(weight)")
        // Set graph data
        graphContainerView.data = weight
        graphContainerView.labels = day
        graphContainerView.targetWeight = weight.first ?? 0
        
        self.lastLiftLabel.text = "Last Lift - \(weight.last ?? 0)kg"
        
        // Refresh the view
        graphContainerView.setNeedsDisplay()
    }
    
    func populateUI(){
        DispatchQueue.main.async { [self] in
            guard let _cellData = self.cellData else { return }
            self.workOutNameLabel.text = _cellData.name
            
            //configure graph data
            configureBarGraph(_cellData: _cellData)
        }
    }
}
//Button Action
extension WorkOutDetailsTableViewCell{
    @IBAction func addNewWeightButtonAction(_sender: UIButton) {
        guard let _cellIndex = self.cellIndex else { return }
        self.delegate?.didSelectedAddWeight(cellIndex: _cellIndex)
    }
}
