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
    
    //set from parent
    weak var delegate : WorkOutDetailsTableViewCellDelegate?
    var cellIndex: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureBarGraph()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//Local Functions
extension WorkOutDetailsTableViewCell{
    func configureBarGraph(){
        // Set graph data
        graphContainerView.data = [10, 40, 50, 60, 55, 70, 65]
        graphContainerView.labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        graphContainerView.targetWeight = 60
        
        // Refresh the view
        graphContainerView.setNeedsDisplay()
    }
}
//Button Action
extension WorkOutDetailsTableViewCell{
    @IBAction func addNewWeightButtonAction(_sender: UIButton) {
        guard let _cellIndex = self.cellIndex else { return }
        self.delegate?.didSelectedAddWeight(cellIndex: _cellIndex)
    }
}
