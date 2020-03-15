//
//  Utilities.swift
//  ExploreWorld
//
//  Created by Dzmitry Zhuk on 5/4/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    static func openURL(_ strUrl: String) {
        if let url = URL(string: strUrl) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func isPad() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == .pad
    }
    
    static func isValidEmail(checkString:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: checkString)
    }
    
    static func showHUD(_ controller: UIViewController, with text: String = "Loading...") {
        let hud = MBProgressHUD.showAdded(to: controller.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = text
    }
    
    static func hideHUD(_ controller: UIViewController) {
        MBProgressHUD.hide(for: controller.view, animated: true)
    }
    
    static func goToHomeScreen() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if let rootController = UIStoryboard.main.instantiateViewController(withIdentifier: Controllers.rootNavController) as? UINavigationController {
            appdelegate.window?.rootViewController = rootController
        }
    }
    
    static func logOut() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        Preferences.sharedInstance.clearData()
        
        if let welcome = UIStoryboard.auth.instantiateViewController(withIdentifier: Controllers.rootAuthController) as? UINavigationController {
            appdelegate.window?.rootViewController = welcome
        }
    }
}
