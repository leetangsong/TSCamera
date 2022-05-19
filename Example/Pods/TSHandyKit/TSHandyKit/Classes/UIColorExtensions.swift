//
//  UIColorExtensions.swift
//  TSKit_Example
//
//  Created by leetangsong on 2022/5/18.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
extension UIColor: TSKitCompatible{}
extension UIColor: TSKitClassCompatible{ }


extension TSKitWrapper where Base == UIColor{
    
}


extension TSKitClassWrapper where Base == UIColor{
    
    public enum TSGradientDirection {
        case level
        case vertical
        case upwardDiagonalLine
        case downDiagonalLine
    }
    
    public static func color(with hex: String,alpha: CGFloat = 1) -> UIColor{
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("0X") {
            cString = cString.replacingOccurrences(of: "0X", with: "")
        }
        if cString.hasPrefix("#") {
            cString = cString.replacingOccurrences(of: "#", with: "")
        }
        if  cString.count != 6 {
            return UIColor.clear
        }

        let rStr = cString.ts[0...1]
        let gStr = cString.ts[2...3]
        let bStr = cString.ts[4...5]

        var  r:CUnsignedInt = 0,g:CUnsignedInt = 0,b:CUnsignedInt = 0
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)


        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))

    }
    
    
    //两色渐变
    public static func colorGradient(with size: CGSize, cornerRadius: CGFloat = 0, direction: TSGradientDirection = .level, startcolor: UIColor, endColor: UIColor , startPoint: CGPoint? = nil, endPoint: CGPoint? = nil)->UIColor?{
        if size == .zero {
            return nil
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: size)
        var _startPoint = CGPoint.zero
        if direction == .downDiagonalLine {
            _startPoint = CGPoint.init(x: 0, y: 1)
        }
        _startPoint = startPoint ?? _startPoint
        gradientLayer.startPoint = _startPoint
        var _endPoint = CGPoint.zero
        switch direction {
        case .level:
            _endPoint = CGPoint.init(x: 1, y: 0)
        case .vertical:
            _endPoint = CGPoint.init(x: 0, y: 1)
        case .upwardDiagonalLine:
            _endPoint = CGPoint.init(x: 1, y: 1)
        case .downDiagonalLine:
            _endPoint = CGPoint.init(x: 1, y: 0)
        }
        gradientLayer.endPoint = endPoint ?? _endPoint;
        gradientLayer.colors = [startcolor.cgColor, endColor.cgColor];
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return UIColor.init(patternImage: image)
    }
    
    //多色渐变
    public static func moreColorGradient(with size: CGSize, cornerRadius: CGFloat = 0 ,startPoint: CGPoint,endPoint: CGPoint,locations: [NSNumber], colors: [AnyObject] )->UIColor?{
        if size == .zero {
            return nil
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: size)
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint;
        gradientLayer.colors = colors;
        let gradientLocations:[NSNumber] = locations
        gradientLayer.locations = gradientLocations
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return UIColor.init(patternImage: image)
    }
    
}
