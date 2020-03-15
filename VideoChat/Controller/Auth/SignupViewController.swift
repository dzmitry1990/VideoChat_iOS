//
//  RootController.swift
//  ColorCall
//
//  Created by Dzmitry Zhuk on 6/14/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class SignupViewController: BaseAuthController {
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    
    var selectedPhoto: UIImage!
    var pickerVC: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for txt in [emailTF, passwordTF, userNameTF] {
            txt?.delegate = self
            self.setTextFieldPlaceholderColor(txt!)
        }
        
        textFieldHeight.constant = Constant.TF_HEIGHT
        btnHeight.constant = Constant.BTN_HEIGHT
        view.layoutIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Custom Actions
    func moveTopView(offset: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.topConst.constant = offset
            self.view.layoutIfNeeded()
        }
    }

    func goToNextScreen() {
        if let vc = UIStoryboard.auth.instantiateViewController(withIdentifier: Controllers.rootPhoneController) as? UINavigationController {
            present(vc, animated: true, completion: nil)
        }
    }

    // MARK: Actions
    @IBAction func signUpBtnAction(_ sender: Any) {
         self.view.endEditing(true)
    
        guard let email = self.emailTF.text, !email.isEmpty else {
            self.showAlertWithErrorMessage("Please add email")
            return
        }
        
        if !Utilities.isValidEmail(checkString: email) {
            self.showAlertWithErrorMessage("Please add valid email")
            return
        }
        
        guard let pwd = self.passwordTF.text, !pwd.isEmpty else {
            self.showAlertWithErrorMessage("Please add password")
            return
        }
        guard let username = self.userNameTF.text, !username.isEmpty else {
            self.showAlertWithErrorMessage("Please add name")
            return
        }
        
        var fname = ""
        var lname = ""
        let names = username.components(separatedBy: " ")
        if names.count > 1 {
            fname = names.first!
            lname = names.last!
        } else {
            fname = username
            lname = " "
        }
        
        sendSignUpRequest(email: email, pwd: pwd, fname: fname, lname: lname)
        
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func keyboardWillHidden(_ notification: NSNotification) {
        if (self.viewWasMoved) {
            self.moveTopView(offset: 0)
        }
    }
    
    override func keyboardWillShown(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var aRect: CGRect = self.topView.frame
            aRect.size.height -= keyboardSize.height
            
            let activeTextFieldRect: CGRect? = self.signUpBtn?.frame
            let activeTextFieldOrigin: CGPoint? = CGPoint(x: (activeTextFieldRect?.origin.x)!, y: (activeTextFieldRect?.origin.y)! + self.signUpBtn.frame.size.height)//activeTextFieldRect?.origin
            
            if (!aRect.contains(activeTextFieldOrigin!)) {
                self.viewWasMoved = true
                self.moveTopView(offset: self.titleLbl.frame.origin.y + self.titleLbl.frame.size.height + 20)
            } else {
                self.viewWasMoved = false
            }
        }
    }

 
    fileprivate func setActive(_ view: UIView, isActive: Bool = false) {
        self.setTextFieldActived(view, isActived: isActive)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var view: UIView
        if textField == userNameTF {
            view = nameView
        } else if textField == passwordTF {
            view = passwordView
        } else {
            view = emailView
        }
        
        setActive(view, isActive: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var view: UIView
        if textField == userNameTF {
            view = nameView
        } else if textField == passwordTF {
            view = passwordView
        } else {
            view = emailView
        }
        
        setActive(view, isActive: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTF {
            userNameTF.becomeFirstResponder()
        } else if textField == userNameTF {
            passwordTF.becomeFirstResponder()
        }
        return true
    }
}

extension SignupViewController {
    fileprivate func sendSignUpRequest(email: String, pwd: String, fname: String, lname: String) {

        self.loadingIndicator.visibility = true
        
        HttpHelper.signUp(email, password: pwd, fName: fname, lName: lname) { (message, success) in
            DispatchQueue.main.async {

                self.loadingIndicator.visibility = false

                if success {
                    self.goToNextScreen()
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
