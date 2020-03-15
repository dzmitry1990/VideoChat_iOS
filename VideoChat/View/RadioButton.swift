//
//  RadioButton.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/20/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    private var ivCheckStatus = UIImageView()
    private var lblTitle = UILabel()
    private let IMG_WIDTH = CGFloat(28)
    private let LEFT_MARGIN = CGFloat(14)
    var checked = false
    
    @IBInspectable var titleStatus: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var selectedBgColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var deselectedBgColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var selectedTextColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var deselectedTextColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var imgCheck: UIImage? {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var imgUncheck: UIImage? {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawButton()
    }
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            
            setNeedsLayout()
        }
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ///Mark -- Adjust layer
        ivCheckStatus.frame = CGRect(x: LEFT_MARGIN, y: (self.bounds.height - IMG_WIDTH) / 2, width: IMG_WIDTH, height: IMG_WIDTH)
        
        lblTitle.text = titleStatus
        lblTitle.font = self.titleLabel?.font
        
        lblTitle.sizeToFit()
        let x = LEFT_MARGIN * 2 + IMG_WIDTH
        lblTitle.frame = CGRect(x: x, y: (self.bounds.height - lblTitle.frame.height) / 2, width: lblTitle.frame.width, height: lblTitle.frame.height)
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        setButtonStatus()
    }
    
    private func setButtonStatus() {
        ivCheckStatus.image = checked ? imgCheck : imgUncheck
        self.backgroundColor = checked ? selectedBgColor : deselectedBgColor
        lblTitle.textColor = checked ? selectedTextColor : deselectedTextColor
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
    }
    
    func setChecked(_ isCheck: Bool) {
        checked = isCheck
        UIView.animate(withDuration: 0.25) {
            DispatchQueue.main.async {
                self.setNeedsLayout()
            }
            
        }
        
    }
    
    private func drawButton() {
        self.addSubview(ivCheckStatus)
        self.addSubview(lblTitle)
    }
}
