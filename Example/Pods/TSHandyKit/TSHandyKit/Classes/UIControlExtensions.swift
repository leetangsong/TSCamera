//
//  UIControlExtensions.swift
//  TSKit_Example
//
//  Created by leetangsong on 2022/5/18.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit


extension TSKitWrapper where Base: UIControl{
    
}

extension UIControl: Swizzling {
    public static func awake() {
        swizzleMethod
        subObjSwizzling()
    }
    private static let swizzleMethod: Void = {
        let originalMethod = #selector(UIControl.sendAction(_:to:for:))
        let swizzledMethod = #selector(UIControl.ts_sendAction(_:to:for:))
        swizzlingForClass(UIControl.self, originalSelector: originalMethod, swizzledSelector: swizzledMethod)
    }()
    
    private struct Keys {
        static var ts_acceptEventInterval_key = "ts_acceptEventInterval_key"
        static var ts_acceptEventTime_key = "ts_acceptEventTime_key"
    }

    
    
    public var ts_acceptEventInterval: TimeInterval? {
        get {
            return objc_getAssociatedObject(self, &Keys.ts_acceptEventInterval_key) as? TimeInterval
        }
        set{
            objc_setAssociatedObject(self, &Keys.ts_acceptEventInterval_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    private var ts_acceptEventTime: TimeInterval {
        get {
            return objc_getAssociatedObject(self, &Keys.ts_acceptEventTime_key) as? TimeInterval ?? 0
        }
        set{
            objc_setAssociatedObject(self, &Keys.ts_acceptEventTime_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    //防止重复点击
    @objc private func ts_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if let acceptEventInterval = self.ts_acceptEventInterval {
            if Date().timeIntervalSince1970 - self.ts_acceptEventTime < acceptEventInterval {
                return
            }
            self.ts_acceptEventTime = Date().timeIntervalSince1970
        }
        self.ts_sendAction(action, to: target, for: event)
    }
    
}
