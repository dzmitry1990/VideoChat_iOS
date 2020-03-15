//
//  RootController.swift
//  ColorCall
//
//  Created by Dzmitry Zhuk on 6/14/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class LoginViewController: BaseAuthController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for txt in [userNameTF, passwordTF] {
            txt?.delegate = self
            self.setTextFieldPlaceholderColor(txt!)
        }
        
        btnHeight.constant = Constant.BTN_HEIGHT
        textFieldHeight.constant = Constant.TF_HEIGHT
        view.layoutIfNeeded()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Custom Actions
    func moveTopView(offset: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.topConst.constant = offset
            self.view.layoutIfNeeded()
        }
    }
    
    func goToHomeScreen() {
        Utilities.goToHomeScreen()
    }
   
    @IBAction func loginBtnAction(_ sender: Any) {
        self.view.endEditing(true)
    
        guard let username = userNameTF.text, !username.isEmpty else {
            self.showAlertWithErrorMessage("Please enter username or email")
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            self.showAlertWithErrorMessage("Please enter password")
            return
        }
        
        sendLoginRequest(username, password: password)
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        if let controller = UIStoryboard.auth.instantiateViewController(withIdentifier: Controllers.signupViewController) as? SignupViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: Notification Actions
    override func keyboardWillShown(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var aRect: CGRect = self.topView.frame
            aRect.size.height -= keyboardSize.height
            
            let loginBtnRect: CGRect? = self.loginBtn?.frame
            let loginBtnOrigin: CGPoint? = loginBtnRect?.origin
            
            if (!aRect.contains(loginBtnOrigin!)) {
                self.viewWasMoved = true
                self.moveTopView(offset: (keyboardSize.height + 20 - (loginBtnOrigin?.y)! + (loginBtnRect?.size.height)!))
            } else {
                self.viewWasMoved = false
            }
        }
    }

    override func keyboardWillHidden(_ notification: NSNotification) {
        if (self.viewWasMoved) {
            self.moveTopView(offset: 0)
        }
    }
    
    
    fileprivate func setActive(_ view: UIView, isActive: Bool = false) {
        self.setTextFieldActived(view, isActived: isActive)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var view: UIView
        if textField == userNameTF {
            view = usernameView
        } else {
            view = passwordView
        }
        
        setActive(view, isActive: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var view: UIView
        if textField == userNameTF {
            view = usernameView
        } else {
            view = passwordView
        }
        
        setActive(view, isActive: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == userNameTF {
            passwordTF.becomeFirstResponder()
        }
        
        return true
    }
}
//Mark -- http
extension LoginViewController {
    func sendLoginRequest(_ username: String, password: String) {
        
        self.loadingIndicator.visibility = true

        HttpHelper.login(username, password: password) { (message, success) in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility = false
                if success {
                    self.goToHomeScreen()
                } else {
                    if let message = message {
                        self.showAlertWithErrorMessage(message)
                    } else {
                        self.showNoInternetConnectionAlert()
                    }
                }
            }
        }
    }
}
