//
//  ViewController.swift
//  FitCanada
//
//  Created by Vijin Raj on 02/09/24.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToHome()
        }
       
    }
    func navigateToHome(){
        
        let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: HomeViewController.identifier) as! HomeViewController
        let nav = UINavigationController(rootViewController: nextVC)
        nav.setNavigationBarHidden(true, animated: false)
        nav.interactivePopGestureRecognizer?.delegate = nil
        nav.interactivePopGestureRecognizer?.isEnabled = true
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}

