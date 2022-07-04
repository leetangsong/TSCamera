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
        removeAnimation(forKey: "MaskLayer_opacityAnimation")
        if animated {
            let animation = CABasicAnimation.init(keyPath: "opacity")
            animation.duration = 1
            animation.fromValue = 0
            animation.toValue = 1
            add(animation, forKey: "MaskLayer_opacityAnimation")
        }
        self.path = path
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 网格层
class TSGridLayer: CAShapeLayer{
    ///网格区域
    var gridRect: CGRect = .zero
    ///网格颜色  默认白色
    var gridColor: UIColor = .white
    ///背景  默认透明
    var bgColor: UIColor = .clear
    
    ///边框线
    lazy var borderLayer: CAShapeLayer = CAShapeLayer()
    ///网格线
    lazy var gridLayer: CAShapeLayer = CAShapeLayer()
    ///边角线
    lazy var cornerLayer: CAShapeLayer = CAShapeLayer()
    
    override init() {
        super.init()
        
        for layer in [borderLayer, gridLayer, cornerLayer] {
            layer.contentsScale = UIScreen.main.scale
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowRadius = 3
            layer.shadowOffset = .zero
            layer.shadowOpacity = 0.5
            addSublayer(layer)
        }
        
    }
    
    
    func setGridRect(_ gridRect: CGRect, animated: Bool){
        if !gridRect.equalTo(self.gridRect) {
            self.gridRect = gridRect
            
            let borderPath = drawBorder()
            let gridPath = drawGrid()
            let cornerPath = drawCorner()
            
            if animated {
                addAnimation(with: borderLayer, path: borderPath)
                addAnimation(with: gridLayer, path: gridPath)
                addAnimation(with: cornerLayer, path: cornerPath)
            }else{
                borderLayer.path = borderPath
                gridLayer.path = gridPath
                cornerLayer.path = cornerPath
            }
           
        }
    }
    
    func addAnimation(with layer: CAShapeLayer, path: CGPath){
        layer.removeAnimation(forKey: "gridLayer_contentsRectAnimation")
        let animation = CABasicAnimation.init(keyPath: "path")
        animation.duration = 0.25
        animation.fromValue = layer.path
        animation.toValue = path
        animation.isRemovedOnCompletion = false
        layer.path = path
        layer.add(animation, forKey: "gridLayer_contentsRectAnimation")
    }
    func drawBorder() -> CGPath{
        borderLayer.lineWidth = 1
        borderLayer.fillColor = bgColor.cgColor
        borderLayer.strokeColor = gridColor.cgColor
        let path = UIBezierPath()
        ///边框
        path.move(to: CGPoint.init(x: gridRect.origin.x, y: gridRect.origin.y))
        path.addLine(to: CGPoint.init(x: gridRect.maxX, y: gridRect.origin.y))
        path.addLine(to: CGPoint.init(x: gridRect.maxX, y: gridRect.maxY))
        path.addLine(to: CGPoint.init(x: gridRect.origin.x, y: gridRect.maxY))
        path.addLine(to: CGPoint.init(x: gridRect.origin.x, y: gridRect.origin.y))
        return path.cgPath
    }
    func drawGrid() -> CGPath{
        gridLayer.lineWidth = 0.3
        gridLayer.fillColor = bgColor.cgColor
        gridLayer.strokeColor = gridColor.cgColor
        let path = UIBezierPath()
        ///横线
        for i in 1...2 {
            path.move(to: CGPoint.init(x: gridRect.minX, y: gridRect.minY + CGFloat(i)*gridRect.height/3))
            path.addLine(to: CGPoint.init(x: gridRect.minX+gridRect.width, y: gridRect.minY + CGFloat(i)*gridRect.height/3))
        }
        
        ///竖线
        for i in 1...2 {
            path.move(to: CGPoint.init(x: gridRect.minX + CGFloat(i)*gridRect.width/3, y: gridRect.minY))
            path.addLine(to: CGPoint.init(x: gridRect.minX + CGFloat(i)*gridRect.width/3, y: gridRect.minY+gridRect.height))
        }
        return path.cgPath
    }
    func drawCorner() -> CGPath{
        cornerLayer.lineWidth = 3
        cornerLayer.fillColor = bgColor.cgColor
        cornerLayer.strokeColor = gridColor.cgColor
        
        let path = UIBezierPath()
        let newRect = gridRect.insetBy(dx: -1, dy: -1)
        let cornerlength = 15.0
        ///左上角
        path.move(to: CGPoint.init(x: newRect.minX, y: newRect.minY+cornerlength))
        path.addLine(to: CGPoint.init(x: newRect.minX, y: newRect.minY))
        path.addLine(to: CGPoint.init(x: newRect.minX+cornerlength, y: newRect.minY))
        
        
        ///右上角
        path.move(to: CGPoint.init(x: newRect.maxX-cornerlength, y: newRect.minY))
        path.addLine(to: CGPoint.init(x: newRect.maxX, y: newRect.minY))
        path.addLine(to: CGPoint.init(x: newRect.maxX, y: newRect.minY+cornerlength))
        
        ///左下角
        path.move(to: CGPoint.init(x: newRect.minX, y: newRect.maxY-cornerlength))
        path.addLine(to: CGPoint.init(x: newRect.minX, y: newRect.maxY))
        path.addLine(to: CGPoint.init(x: newRect.minX+cornerlength, y: newRect.maxY))
        
        ///右下角
        path.move(to: CGPoint.init(x: newRect.maxX-cornerlength, y: newRect.maxY))
        path.addLine(to: CGPoint.init(x: newRect.maxX, y: newRect.maxY))
        path.addLine(to: CGPoint.init(x: newRect.maxX, y: newRect.maxY-cornerlength))
        
        return path.cgPath
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
