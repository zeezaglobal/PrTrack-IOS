//
//  UIView.swift
//  FitCanada
//
//  Created by Vijin Raj on 30/11/24.
//

import Foundation
import UIKit

extension UIView {
    
    //Fetch controller name
    static var identifier: String {
        
        return String(describing: self).components(separatedBy: ".").last!
    }
}