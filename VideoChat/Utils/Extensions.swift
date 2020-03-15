//
//  Extensions.swift
//  ExploreWorld
//
//  Created by Dzmitry Zhuk on 5/2/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var call: UIStoryboard {
        return UIStoryboard(name: "Call", bundle: nil)
    }
    
    static var search: UIStoryboard {
        return UIStoryboard(name: "Search", bundle: nil)
    }
 
    static var camera: UIStoryboard {
        return UIStoryboard(name: "Camera", bundle: nil)
    }
    
    static var chats: UIStoryboard {
        return UIStoryboard(name: "Chats", bundle: nil)
    }
    
    static var auth: UIStoryboard {
        return UIStoryboard(name: "Auth", bundle: nil)
    }
    
    static var profile: UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: nil)
    }
}

extension UISearchBar {
    func removeBackgroundImageView(){
        if let view:UIView = self.subviews.first {
            for curr in view.subviews {
                guard let searchBarBackgroundClass = NSClassFromString("UISearchBarBackground") else {
                    return
                }
                if curr.isKind(of:searchBarBackgroundClass){
                    if let imageView = curr as? UIImageView{
                        imageView.removeFromSuperview()
                        break
                    }
                }
            }
        }
    }
}

extension UIView {
    func setAlphaGradient(_ frame: CGRect, startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]) {
        let mask = CAGradientLayer()
        mask.startPoint = startPoint
        mask.endPoint = endPoint
        let whiteColor = UIColor.white
        mask.colors = [whiteColor.withAlphaComponent(1.0).cgColor,whiteColor.withAlphaComponent(1.0),whiteColor.withAlphaComponent(0.0).cgColor]
        mask.locations = locations
        mask.frame = frame
        self.layer.mask = mask
    }
    
    func roundedCorners(_ corners: UIRectCorner, size: CGFloat){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: size, height: size))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func applyBlurEffect(amount:CGFloat) -> UIImage{
        let imageToBlur = CIImage(image: self)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        blurfilter?.setValue(amount, forKey: "inputRadius")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        return blurredImage
    }
    
    func imageWithColor (newColor: UIColor?) -> UIImage? {
        
        if let newColor = newColor {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            
            newColor.setFill()
            context.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }

        
        return self
    }
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UITextField {
    func applyCustomClearButton() {
        clearButtonMode = .never
        rightViewMode   = .whileEditing
        
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        clearButton.setImage(#imageLiteral(resourceName: "ic_clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearClicked(sender:)), for: .touchUpInside)
        rightView = clearButton
    }
    
    @objc func clearClicked(sender:UIButton) {
        text = ""
    }
}

extension UIFont {
    fileprivate static var fontFor: ( _ name: String, _ size: CGFloat) -> UIFont = { fontName, size in
        guard let font = UIFont(name: fontName, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    //SF Pro Display
    static var sfProDisplayHeavyItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-HeavyItalic", size)
    }
    
    static var sfProDisplayThinItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-ThinItalic", size)
    }
    
    static var sfProDisplayUltralightFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Ultralight", size)
    }
    
    static var sfProDisplayHeavyFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Heavy", size)
    }
    
    static var sfProDisplayBoldItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-BoldItalic", size)
    }
    
    static var sfProDisplaySemiboldItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-SemiboldItalic", size)
    }
    
    static var sfProDisplayRegularFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Regular", size)
    }
    
    static var sfProDisplayBoldFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Bold", size)
    }
    
    static var sfProDisplayMediumItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-MediumItalic", size)
    }
    
    static var sfProDisplayThinFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Thin", size)
    }
    
    static var sfProDisplaySemiboldFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Semibold", size)
    }
    
    static var sfProDisplayBlackItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-BlackItalic", size)
    }
    
    static var sfProDisplayLightFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Light", size)
    }
    
    static var sfProDisplayUltralightItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-UltralightItalic", size)
    }
    
    static var sfProDisplayItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Italic", size)
    }
    
    static var sfProDisplayLightItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-LightItalic", size)
    }
    
    static var sfProDisplayBlackFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Black", size)
    }
    
    static var sfProDisplayMediumFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProDisplay-Medium", size)
    }
    
    // SF Pro Text
    static var sfProTextHeavyFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-Heavy", size)
    }
    
    static var sfProTextLightItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-LightItalic", size)
    }
    
    static var sfProTextHeavyItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-HeavyItalic", size)
    }
    
    static var sfProTextMediumFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-Medium", size)
    }
    
    static var sfProTextItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-Italic", size)
    }
    
    static var sfProTextBoldFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-Bold", size)
    }
    
    static var sfProTextSemiboldItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-SemiboldItalic", size)
    }
    
    static var sfProTextLightFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-Light", size)
    }
    
    static var sfProTextMediumItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-MediumItalic", size)
    }
    
    static var sfProTextBoldItalicFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-BoldItalic", size)
    }
    
    static var sfProTextRegularFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-Regular", size)
    }
    
    static var sfProTextSemiboldFont: (CGFloat) -> UIFont = { size in
        return UIFont.fontFor("SFProText-Semibold", size)
    }
}
