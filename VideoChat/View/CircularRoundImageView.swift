import UIKit

class CircularRoundImageView: UIImageView {
    @IBInspectable var circleBorderColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var circleBorderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = bounds.height / 2.0
        self.layer.borderWidth = circleBorderWidth
        self.layer.borderColor = circleBorderColor.cgColor
        self.layer.masksToBounds = true        
    }
}
