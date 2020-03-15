//
//  StyleButton.swift
//  ExploreWorld
//
//  Created by Dzmitry Zhuk on 4/30/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class StyleButton: UIButton {
    private var gradientView: GradientView!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0.5 {
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
        
        gradientView.frame = self.bounds
        
        gradientView.topColor = topColor
        gradientView.bottomColor = bottomColor
        gradientView.shadowColor = shadowColor
        gradientView.shadowX = shadowX
        gradientView.shadowY = shadowY
        gradientView.shadowBlur = shadowBlur
        gradientView.startPointX = startPointX
        gradientView.startPointY = startPointY
        gradientView.endPointX = endPointX
        gradientView.endPointY = endPointY
        gradientView.cornerRadius = cornerRadius
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
       super.sendAction(action, to: target, for: event)
    }
    
    private func drawButton() {
        gradientView = GradientView()
        gradientView.isUserInteractionEnabled = false
        self.addSubview(gradientView)
    }

}
