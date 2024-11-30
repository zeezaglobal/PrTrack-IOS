//
//  UIViewController.swift
//  FitCanada
//
//  Created by Vijin Raj on 12/09/24.
//

import Foundation
import UIKit
extension UIViewController {
    
    //Fetch controller name
    static var identifier: String {
        
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    func remove(_ controller: UIViewController, completion: (() -> ())? = nil) {
        
        controller.removeFromParent()
        controller.view?.removeFromSuperview()
        controller.didMove(toParent: nil)
        completion?()
    }
    
    
    func add(_ controller: UIViewController, parentView: UIView) {
        
        controller.view.frame = parentView.bounds
        parentView.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
    }
    
    
    func removeAllChilds(_ completion: @escaping () -> ()) {
        
        func recursiveRemoval() {
            
            if self.children.count > 0 {
                
                if let controller = self.children.first {
                    
                    self.remove(controller) {
                        
                        recursiveRemoval()
                    }
                }
                
            } else {
                
                completion()
            }
        }
        
        recursiveRemoval()
    }
    
    func push(  controller: UIViewController,  animated: Bool = true){
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(_ animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
    func popToRootViewController(_ animated: Bool = true){
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    func popToViewController(ofClass: AnyClass, _ animated: Bool = true) {
        self.navigationController?.popToViewController(ofClass: ofClass, animated: animated)
    }
    
    func removeAddedSubViews(_ controller: UIViewController){
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
}
