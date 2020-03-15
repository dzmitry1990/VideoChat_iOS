//
//  SendPhoneNumberController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/19/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class SendPhoneNumberController: BaseAuthController {

    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfHeight: NSLayoutConstraint!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var agreeLabel: ActiveLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfHeight.constant = Constant.TF_HEIGHT
        btnHeight.constant = Constant.BTN_HEIGHT
        
        tfPhoneNumber.delegate = self
        configActiveLabel()
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func backgroundDidTap(_: AnyObject) {
        view.endEditing(true)
    }
    
    private func configActiveLabel() {
        let customType1 = ActiveType.custom(pattern: "\\sTerms and Conditions\\b")
        let customType2 = ActiveType.custom(pattern: "\\sPrivacy Policy\\b")
        
        agreeLabel.customize { label in
            label.text = "By clicking “Send Code” above, you are agreeing to our Terms and Conditions and Privacy Policy."
            label.numberOfLines = 0
            
            label.textColor = UIColor.init(rgb: 0xBFBFBF)
            label.URLColor = UIColor.white
            label.URLSelectedColor = UIColor.white
            
            label.handleURLTap({ (url) in
                Utilities.openURL(url.absoluteString)
            })
            
            label.enabledTypes = [.mention, .hashtag, .url, customType1, customType2]
            
            label.customColor[customType1] = UIColor.white
            label.customSelectedColor[customType1] = UIColor.white
            
            label.customColor[customType2] = UIColor.white
            label.customSelectedColor[customType2] = UIColor.white
            
            label.handleCustomTap(for: customType1) { element in
                Utilities.openURL(Urls.TERMS_URL)
            }
            
            label.handleCustomTap(for: customType2) { element in
                Utilities.openURL(Urls.POLICY_URL)
            }
            
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case .mention:
                    break
                case .hashtag:
                    break
                case .url:
                    atts[NSAttributedStringKey.underlineStyle] = NSUnderlineStyle.styleSingle.rawValue
                    break
                default :
                    break
                }
                
                return atts
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Mark - Action Defines
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func goToNextScreen() {
        if let vc = UIStoryboard.auth.instantiateViewController(withIdentifier: Controllers.verifyCodeController) as? VerifyNumberController {
            vc.phoneNumber = tfPhoneNumber.text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        guard let phoneNum = tfPhoneNumber.text, !phoneNum.isEmpty else {
            self.showAlertWithErrorMessage("Enter your phone number.")
            return
        }
        
        sendPhoneNumber(phoneNum)
    }
    
}

extension SendPhoneNumberController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

//Mark -- Http
extension SendPhoneNumberController {
    fileprivate func sendPhoneNumber(_ phoneNum: String) {
        self.loadingIndicator.visibility = true
        
        HttpHelper.verifyPhoneNumber(phoneNum) { (success, message) in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility = false
                
                #if DEBUG
                self.goToNextScreen()
                return
                #endif
                
                if success {
                    self.goToNextScreen()
                } else {
                    if let mess = message {
                        self.showAlertWithErrorMessage(mess)
                    } else {
                        self.showAlertWithErrorMessage("Failed, try later.")
                    }
                }
            }
        }
    }
}
