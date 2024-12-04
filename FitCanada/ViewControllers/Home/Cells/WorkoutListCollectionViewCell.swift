//
//  WorkoutListCollectionViewCell.swift
//  FitCanada
//
//  Created by Vijin Raj on 17/09/24.
//

import UIKit

class WorkoutListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var workOutNameLabel : UILabel!
    
    //Set from parent
    var cellData:BodyPart?{
        didSet{
            self.populateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populateUI(){
        DispatchQueue.main.async { [self] in
            guard let _cellData = self.cellData else { return }
            self.workOutNameLabel.text = _cellData.name
        }
    }

}
