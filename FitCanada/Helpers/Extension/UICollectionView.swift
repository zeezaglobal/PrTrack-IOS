//
//  UICollectionView.swift
//  FitCanada
//
//  Created by Vijin Raj on 17/09/24.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    //Fetch controller name
    static var identifier: String {
        
        return String(describing: self).components(separatedBy: ".").last!
    }
}
