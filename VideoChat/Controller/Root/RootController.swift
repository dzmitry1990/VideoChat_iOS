//
//  RootController.swift
//  ColorCall
//
//  Created by Dzmitry Zhuk on 4/10/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class RootController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseNotification(notification:)), name: .UIApplicationWillEnterForeground, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func purchaseNotification(notification: Notification ) {
        if !MKStoreKit.shared().isSubscriptionForAnyProductActive() {
            if let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeController") as? WelcomeController {
                controller.isPresented = true
                
                self.present(controller, animated: false, completion: nil)
            }
        }
    }
}

