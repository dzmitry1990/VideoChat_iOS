//
//  GetStartedController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/20/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
enum HumanType {
    case guy
    case girl
}

class GetStartedController: BaseAuthController {

    @IBOutlet weak var tfAge: UITextField!
    
    @IBOutlet weak var tfSnapchat: UITextField!
    
    @IBOutlet weak var guyView: UIView!
    
    @IBOutlet weak var girlView: UIView!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tfHeight: NSLayoutConstraint!
    
    private var selectedType: HumanType!
    
    //Mark - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        chooseOption(.girl)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        view.addGestureRecognizer(tapRecognizer)
        
        for txt in [tfAge, tfSnapchat] {
            txt?.delegate = self
            setTextFieldPlaceholderColor(txt!)
        }
        
        btnHeight.constant = Constant.BTN_HEIGHT
        tfHeight.constant = Constant.TF_HEIGHT
    }

    @objc func backgroundDidTap(_: AnyObject) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func chooseOption(_ type: HumanType) {
        self.setTextFieldActived(guyView, isActived: type == .guy)
        self.setTextFieldActived(girlView, isActived: type == .girl)
        
        selectedType = type
    }
    
    //Mark - Action define
    @IBAction func nextAction(_ sender: Any) {
        guard let age = tfAge.text, !age.isEmpty else { return }
        guard let snapchatId = tfSnapchat.text, !snapchatId.isEmpty else { return }
        
        let sAge = age as NSString
        let iAge = sAge.integerValue
        
        let type = selectedType == .guy ? Gender.male : Gender.female
        
        updateUserInfo(iAge, snapchatId: snapchatId, type: type)
        
    }
    
    fileprivate func goToNext() {
        if let vc = UIStoryboard.auth.instantiateViewController(withIdentifier: Controllers.permissionController) as? PermissionController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onGuyTapped(_ sender: Any) {
        chooseOption(.guy)
    }
    
    @IBAction func onGirlTapped(_ sender: Any) {
        chooseOption(.girl)
    }
    
}

extension GetStartedController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfAge {
            tfSnapchat.becomeFirstResponder()
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}

//Mark - http
extension GetStartedController {
    fileprivate func updateUserInfo(_ age: Int, snapchatId: String, type: String) {
   
        self.loadingIndicator.visibility = true
        let userId = Preferences.sharedInstance.userId
        
        HttpHelper.updateUser(userId, age: age, snapchat: snapchatId, gender: type) { success in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility = false
                
                if success {
                    let preferences = Preferences.sharedInstance
                    preferences.setSnapchatUsername(snapchatId)
                    preferences.setAge(age)
                    
                    self.goToNext()
                } else {
                    self.showAlertWithErrorMessage("Failed, Try later.")
                }
            }
        }
    }
}
