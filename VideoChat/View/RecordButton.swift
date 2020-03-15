//
//  RadioButton.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/20/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

@objc public enum RecordButtonState : Int {
    case recording, idle, hidden;
}

@objc open class RecordButton : UIButton {
    
    open var buttonColor: UIColor! = .yellow{
        didSet {
            circleLayer.backgroundColor = buttonColor.cgColor
        }
    }
    
    open var buttonBorderColor: UIColor! = .white {
        didSet {
            circleBorder.borderColor = buttonBorderColor.cgColor
        }
    }
    
    open var progressColor: UIColor!  = .white {
        didSet {
            gradientMaskLayer.colors = [progressColor.cgColor, progressColor.cgColor]
        }
    }
    
    /// Closes the circle and hides when the RecordButton is finished
    open var closeWhenFinished: Bool = false
    
    open var buttonState : RecordButtonState = .idle {
        didSet {
            switch buttonState {
            case .idle:
                self.alpha = 1.0
                currentProgress = 0
                setProgress(0)
                setRecording(false)
            case .recording:
                self.alpha = 1.0
                setRecording(true)
            case .hidden:
                self.alpha = 0
            }
        }
        
    }
    
    fileprivate var circleLayer: CALayer!
    fileprivate var circleBorder: CALayer!
    fileprivate var progressLayer: CAShapeLayer!
    fileprivate var gradientMaskLayer: CAGradientLayer!
    fileprivate var currentProgress: CGFloat! = 0

    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(RecordButton.didTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(RecordButton.didTouchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(RecordButton.didTouchUp), for: .touchUpOutside)
        
        self.drawButton()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addTarget(self, action: #selector(RecordButton.didTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(RecordButton.didTouchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(RecordButton.didTouchUp), for: .touchUpOutside)
        
        self.drawButton()
    }
    
    
    fileprivate func drawButton() {
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
        self.layer.cornerRadius = self.frame.size.width / 2

        let layer = self.layer
        circleLayer = CALayer()
        circleLayer.backgroundColor = buttonColor.cgColor
        
        let size: CGFloat = self.frame.size.width / 1.28
        circleLayer.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        circleLayer.position = CGPoint(x: self.bounds.midX,y: self.bounds.midY)
        circleLayer.cornerRadius = size / 2
        layer.insertSublayer(circleLayer, at: 0)
        
        circleBorder = CALayer()
        circleBorder.backgroundColor = UIColor.clear.cgColor
        circleBorder.borderWidth = 4
        circleBorder.borderColor = buttonBorderColor.cgColor
        circleBorder.bounds = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        circleBorder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        circleBorder.position = CGPoint(x: self.bounds.midX,y: self.bounds.midY)
        circleBorder.cornerRadius = self.frame.size.width / 2
        layer.insertSublayer(circleBorder, at: 0)
        
        let startAngle: CGFloat = CGFloat(Double.pi) + CGFloat(Double.pi / 2)
        let endAngle: CGFloat = CGFloat(Double.pi) * 3 + CGFloat(Double.pi / 2)
        let centerPoint: CGPoint = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        gradientMaskLayer = self.gradientMask()
        progressLayer = CAShapeLayer()
        progressLayer.path = UIBezierPath(arcCenter: centerPoint, radius: self.frame.size.width / 2 - 2, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = buttonBorderColor.cgColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        gradientMaskLayer.mask = progressLayer
        layer.insertSublayer(gradientMaskLayer, at: 0)
    }
    
    fileprivate func setRecording(_ recording: Bool) {
        
        let duration: TimeInterval = 0.15
        circleLayer.contentsGravity = "center"
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 1
        scale.duration = duration
        scale.fillMode = kCAFillModeForwards
        scale.isRemovedOnCompletion = false
        
        let color = CABasicAnimation(keyPath: "backgroundColor")
        color.duration = duration
        color.fillMode = kCAFillModeForwards
        color.isRemovedOnCompletion = false
        color.toValue =  buttonColor.cgColor
        
        let circleAnimations = CAAnimationGroup()
        circleAnimations.isRemovedOnCompletion = false
        circleAnimations.fillMode = kCAFillModeForwards
        circleAnimations.duration = duration
        circleAnimations.animations = [scale, color]
        
        let borderColor: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColor.duration = duration
        borderColor.fillMode = kCAFillModeForwards
        borderColor.isRemovedOnCompletion = false
        borderColor.toValue = recording ? UIColor.clear.cgColor : buttonBorderColor
        
        let borderScale = CABasicAnimation(keyPath: "transform.scale")
        borderScale.fromValue = 1
        borderScale.toValue = 1
        borderScale.duration = duration
        borderScale.fillMode = kCAFillModeForwards
        borderScale.isRemovedOnCompletion = false
        
        let borderAnimations = CAAnimationGroup()
        borderAnimations.isRemovedOnCompletion = false
        borderAnimations.fillMode = kCAFillModeForwards
        borderAnimations.duration = duration
        borderAnimations.animations = [borderColor, borderScale]
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = recording ? 0.0 : 1.0
        fade.toValue = recording ? 1.0 : 0.0
        fade.duration = duration
        fade.fillMode = kCAFillModeForwards
        fade.isRemovedOnCompletion = false
        
        circleLayer.add(circleAnimations, forKey: "circleAnimations")
        progressLayer.add(fade, forKey: "fade")
        circleBorder.add(borderAnimations, forKey: "borderAnimations")
        
    }
    
    fileprivate func gradientMask() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.locations = [0.0, 1.0]
        let topColor = progressColor
        let bottomColor = progressColor
        gradientLayer.colors = [topColor!.cgColor, bottomColor!.cgColor]
        return gradientLayer
    }
    
    override open func layoutSubviews() {
        circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        circleLayer.position = CGPoint(x: self.bounds.midX,y: self.bounds.midY)
        circleBorder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        circleBorder.position = CGPoint(x: self.bounds.midX,y: self.bounds.midY)
        super.layoutSubviews()
    }
    
    
    @objc open func didTouchDown(){
//        self.buttonState = .recording
    }
    
    @objc open func didTouchUp() {
//        if(closeWhenFinished) {
//            self.setProgress(1)
//
//            UIView.animate(withDuration: 0.3, animations: {
//                self.buttonState = .hidden
//                }, completion: { completion in
//                    self.setProgress(0)
//                    self.currentProgress = 0
//            })
//        } else {
//            self.buttonState = .idle
//        }
    }
    
    
    /**
    Set the relative length of the circle border to the specified progress
    
    - parameter newProgress: the relative lenght, a percentage as float.
    */
    open func setRecord(_ isRecording: Bool) {
        self.buttonState = isRecording ? .recording : .idle
    }
    
    open func setProgress(_ newProgress: CGFloat) {
        progressLayer.strokeEnd = newProgress
    }
    
    
}

