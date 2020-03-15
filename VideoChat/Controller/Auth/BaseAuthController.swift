//
//  BaseAuthController.swift
//  ColorCall
//
//  Created by Dzmitry Zhuk on 6/14/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

open class BaseAuthController: BaseViewController {
    private let activeColor = UIColor(white: 1.0, alpha: 0.25)
    private let deActiveColor = UIColor.init(rgb: 0x321745)
    private let placeholderColor = UIColor(white: 1.0, alpha: 0.6)
    var viewWasMoved: Bool = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardWillShown(notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardWillHidden(notification)
    }
    
    func keyboardWillShown(_ notification: NSNotification) {
        
    }
    
    func keyboardWillHidden(_ notification: NSNotification) {
        
    }
    
    func setTextFieldActived(_ view: UIView, isActived: Bool) {
        view.backgroundColor = isActived ? activeColor : deActiveColor
    }
    
    func setTextFieldPlaceholderColor(_ textField: UITextField, placeholderText: String = "") {
        var placeholderText = placeholderText
        if placeholderText.isEmpty {
            placeholderText = textField.placeholder ?? ""
        }
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                   attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
    }
}
