//
//  TSGridView.swift
//  TSCamera_Example
//
//  Created by leetangsong on 2022/6/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

///网格遮罩层 后面背景
class TSGridMaskLayer: CAShapeLayer{
    ///遮罩颜色
    var maskColor: UIColor = .black.withAlphaComponent(0.6){
        didSet{
            fillColor = maskColor.cgColor
            fillRule = .evenOdd
        }
    }
    ///遮罩区域的非交集区域  中间空白（网格）区域
    var maskRect: CGRect = .zero
    
    override init(){
        super.init()
        fillRule = .evenOdd
        contentsScale = UIScreen.main.scale
    }
    
    func setMaskRect(_ maskRect: CGRect, animated: Bool){
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(maskRect)
        removeAnimation(forKey: "MaskLayer_opacityAnimat")
        if animated {
            let animation = CABasicAnimation.init(keyPath: "opacity")
            animation.duration = 1
            animation.fromValue = 0
            animation.toValue = 1
            self.path = path
            add(animation, forKey: "MaskLayer_opacityAnimat")
        }else{
            self.path = path
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 网格层
class TSGridLayer: CAShapeLayer{
    
}





@objc protocol TSGridViewDelegate: AnyObject{
    ///开始调整大小
    @objc optional func gridViewDidBeginResizing(_ gridView: TSGridView)
    ///正在调整大小
    @objc optional func gridViewDidResizing(_ gridView: TSGridView)
    ///结束调整大小
    @objc optional func gridViewDidEndResizing(_ gridView: TSGridView)
}

class TSGridView: UIView {
    ///网格区域
    var gridRect: CGRect = CGRect.zero
    ///网格 最小尺寸  默认 60x60
    var minGridSize: CGSize = CGSize.init(width: 60, height: 60)
    ///网格最大区域  默认 CGRectInset(self.bounds, 20, 20)
    var maxGridRect: CGRect = .zero
    ///原来尺寸 默认CGRectInset(self.bounds, 20, 20).size
    var originalGridSize: CGSize = .zero
    
    weak var delegate: TSGridViewDelegate?
    ///显示遮罩层  半透明黑色  默认 YES
    var showMaskLayer: Bool = true
    /// 是否正在拖动
    var dragging: Bool = false

}