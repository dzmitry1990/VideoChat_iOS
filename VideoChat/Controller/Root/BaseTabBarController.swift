//
//  BaseTabBarController.swift
//  ColorCall
//
//  Created by Dzmitry Zhuk on 4/10/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        self.delegate = self
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

//            if viewController is DetectorController {
//                let vc = UIStoryboard.camera.instantiateViewController(withIdentifier: Controllers.cameraController)
//
//                self.present(vc, animated: true, completion: nil)
//                return false
//
//            }
  
        return true
    }
}
  
