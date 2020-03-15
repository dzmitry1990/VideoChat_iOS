//
//  VerifyNumberController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/19/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class VerifyNumberController: BaseAuthController {

    @IBOutlet weak var lblPhoneNumber: UILabel!
    var phoneNumber: String!
    
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    fileprivate var activeIndex = 0
    fileprivate var txts = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for txt in [txt1, txt2, txt3, txt4] {
            txts.append(txt!)
            txt?.delegate = self
        }
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        view.addGestureRecognizer(tapRecognizer)
        
        btnHeight.constant = Constant.BTN_HEIGHT
        
        if let phone = phoneNumber {
            lblPhoneNumber.text = phone
        }
    }
    
    @objc func backgroundDidTap(_: AnyObject) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func goToContinue() {
        if let vc = UIStoryboard.auth.instantiateViewController(withIdentifier: Controllers.getStartedController) as? GetStartedController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        sendCode()
    }
    
    @IBAction func secondCodeAction(_ sender: Any) {
        sendCode()
    }
    
    fileprivate func sendCode() {
        guard let t1 = txt1.text, !t1.isEmpty else {
            return
        }
        guard let t2 = txt1.text, !t2.isEmpty else {
            return
        }
        guard let t3 = txt1.text, !t3.isEmpty else {
            return
        }
        guard let t4 = txt1.text, !t4.isEmpty else {
            return
        }
        
        let verifycode = t1 + t2 + t3 + t4
        
        guard let phoneNumber = phoneNumber else {
            return
        }
        
        verifyCode(phoneNumber, code: verifycode)
    }
}

extension VerifyNumberController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeIndex = txts.index(of: textField) ?? 0
        self.setTextFieldActived(textField, isActived: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text ?? ""
        
        self.setTextFieldActived(textField, isActived: !txt.isEmpty)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = string
        textField.resignFirstResponder()
        
        if string.isEmpty {
            if 0 < activeIndex {
                let text = txts[activeIndex - 1]
                text.becomeFirstResponder()
            }
        } else {
            if txts.count - 1 > activeIndex {
                let text = txts[activeIndex + 1]
                text.becomeFirstResponder()
            }
        }
        
        return false
    }
}

//Mark -- http
extension VerifyNumberController {
    fileprivate func verifyCode(_ phoneNum: String, code: String) {
        self.loadingIndicator.visibility = true
        
        HttpHelper.verifyCode(phoneNum, code: code) { (success, message) in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility = false
                
                #if DEBUG
                self.showAlert(with: "Phone number verified", message: nil, handler: { action in
                    self.goToContinue()
                })
                return
                #endif
                
                if success {
                    self.showAlert(with: "Phone number verified", message: nil, handler: { action in
                        self.goToContinue()
                    })
                } else {
                    if let mess = message {
                        self.showAlertWithErrorMessage(mess)
                    } else {
                        self.showAlertWithErrorMessage("Failed, Try later.")
                    }
                }
            }
        }
    }
}
