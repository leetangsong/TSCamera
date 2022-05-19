//
//  TSApp.swift
//  TSKit_Example
//
//  Created by leetangsong on 2022/5/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

public struct TSApp{
    public static var screenWidth: CGFloat{
        return UIScreen.main.bounds.size.width
    }
    public static var screenHeight: CGFloat{
        return UIScreen.main.bounds.size.height
    }
    
    public static var statusBarHeight: CGFloat{
        return isIphoneX ? safeAreaInsets.top : 20
    }
    
    public static var naviBarHeight: CGFloat{
        return statusBarHeight + 44
    }
    public static var tabBarHeight: CGFloat{
        return safeAreaInsets.bottom + 49
    }
    
    public static var isIphoneX: Bool{
        return Int(screenHeight/screenWidth*100) == 216
    }
    
    public static var safeAreaInsets: UIEdgeInsets{
        var window = UIApplication.shared.windows.first
        if (window?.isKeyWindow ?? false) == false  {
            if let keyWindow = UIApplication.shared.keyWindow {
                if keyWindow.bounds.equalTo(UIScreen.main.bounds) {
                    window = keyWindow
                }
            }
        }
        if #available(iOS 11.0, *) {
            let insets = window?.safeAreaInsets ?? .zero
            return insets
        }
        
        return .zero
    }
    
    //app名字
    public static let infoDict = Bundle.main.localizedInfoDictionary ?? Bundle.main.infoDictionary
    public static let appName = (infoDict?["CFBundleDisplayName"] ?? infoDict?["CFBundleName"]) as! String
    
    
}
