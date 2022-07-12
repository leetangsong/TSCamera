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
    override init(layer: Any) {
        super.init(layer: layer)
    }
    func setMaskRect(_ maskRect: CGRect, animated: Bool, isHidden: Bool = true){
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(maskRect)
        if animated {
            opacity = isHidden ? 1:0
            UIView.animate(withDuration: 0.25) {
                self.opacity = isHidden ? 0:1
            }
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



@objc protocol TSResizeControlDelegate: AnyObject{
    ///开始调整大小
    @objc optional func resizeControlDidBeginResizing(_ resizeControl: TSResizeControl)
    ///正在调整大小
    @objc optional func resizeControlDidResizing(_ resizeControl: TSResizeControl)
    ///结束调整大小
    @objc optional func resizeControlDidEndResizing(_ resizeControl: TSResizeControl)
}

class TSResizeControl: UIView {
    weak var delegate: TSResizeControlDelegate?
    var translation: CGPoint = .zero
    var startPoint: CGPoint = .zero
    var isEnabled: Bool = true{
        didSet{
            gestureRecognizer.isEnabled = isEnabled
        }
    }
    var gestureRecognizer: UIPanGestureRecognizer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        gestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan))
        addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer){
        let translationPoint = pan.translation(in: self.superview)
        switch pan.state {
        case .began:
            startPoint = CGPoint.init(x: round(translationPoint.x), y: translationPoint.y)
            delegate?.resizeControlDidBeginResizing?(self)
            break
        case .changed:
            translation = CGPoint.init(x: round(startPoint.x + translationPoint.x), y: round(startPoint.y + translationPoint.y))
            delegate?.resizeControlDidResizing?(self)
            break
        case .ended, .cancelled:
            delegate?.resizeControlDidEndResizing?(self)
            break
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



//网格四角和边的 可控范围
let kTSControlWidth: CGFloat = 30

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
    var gridRect: CGRect{
        set{
            setGridRect(newValue, isMaskLayer: true)
        }get{
            return _gridRect
        }

    }
    private var _gridRect: CGRect = CGRect.zero
    ///网格 最小尺寸  默认 60x60
    var minGridSize: CGSize = CGSize.init(width: 60, height: 60)
    ///网格最大区域  默认 CGRectInset(self.bounds, 20, 20)
    var maxGridRect: CGRect = .zero
    ///原来尺寸 默认CGRectInset(self.bounds, 20, 20).size
    var originalGridSize: CGSize = .zero
    
    weak var delegate: TSGridViewDelegate?
    ///显示遮罩层  半透明黑色  默认 YES
    var showMaskLayer: Bool = true{
        didSet{
            if oldValue != showMaskLayer {
                gridMaskLayer.setMaskRect(gridRect, animated: true, isHidden: !showMaskLayer)
            }
        }
    }
    /// 是否正在拖动
    var dragging: Bool = false
    
    //高亮网格框的初始区域
    var initialRect: CGRect = .zero
    
    lazy var gridLayer: TSGridLayer = {
        let layer = TSGridLayer()
        layer.frame = bounds
        layer.gridColor = .white
        layer.gridRect = bounds.insetBy(dx: 20, dy: 20)
        return layer
    }()
    
    lazy var gridMaskLayer: TSGridMaskLayer = {
        let layer = TSGridMaskLayer()
        layer.frame = bounds
        layer.maskColor = .black.withAlphaComponent(0.6)
        return layer
    }()
    
    
    //四个角
    var topLeftCornerView: TSResizeControl!
    var topRightCornerView: TSResizeControl!
    var bottomLeftCornerView: TSResizeControl!
    var bottomRightCornerView: TSResizeControl!
    //四条边
    var topEdgeView: TSResizeControl!
    var leftEdgeView: TSResizeControl!
    var bottomEdgeView: TSResizeControl!
    var rightEdgeView: TSResizeControl!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridLayer.frame = bounds
        gridMaskLayer.frame = bounds
        updateResizeControlFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGridRect(_ gridRect: CGRect, isMaskLayer: Bool, animated: Bool = false){
        if !_gridRect.equalTo(gridRect) {
            _gridRect = gridRect
            setNeedsLayout()
            gridLayer.setGridRect(gridRect, animated: animated)
            if isMaskLayer {
                gridMaskLayer.setMaskRect(gridRect, animated: animated)
            }
        }
        
    }
    
    private func setupUI(){
        minGridSize = CGSize.init(width: 60, height: 60)
        maxGridRect = bounds.insetBy(dx: 20, dy: 20)
        originalGridSize  = gridRect.size
        showMaskLayer = true
        
        layer.addSublayer(gridMaskLayer)
        layer.addSublayer(gridLayer)
        
        topLeftCornerView = createResizeControl()
        topRightCornerView = createResizeControl()
        bottomLeftCornerView = createResizeControl()
        bottomRightCornerView = createResizeControl()
        
        topEdgeView = createResizeControl()
        leftEdgeView = createResizeControl()
        bottomEdgeView = createResizeControl()
        rightEdgeView = createResizeControl()
    }
    
    
    
    private func createResizeControl() -> TSResizeControl{
        let control = TSResizeControl.init(frame: CGRect.init(x: 0, y: 0, width: kTSControlWidth, height: kTSControlWidth))
        control.delegate = self
        addSubview(control)
        control.isUserInteractionEnabled = true
        return control
    }
    
    private func updateResizeControlFrame(){
        topLeftCornerView.frame = CGRect.init(origin: CGPoint.init(x: gridRect.minX-topLeftCornerView.bounds.width/2, y: gridRect.minY-topLeftCornerView.bounds.height/2), size: topLeftCornerView.bounds.size)
        topRightCornerView.frame = CGRect.init(origin: CGPoint.init(x: gridRect.maxX-topRightCornerView.bounds.width/2, y: gridRect.minY-topRightCornerView.bounds.height/2), size: topRightCornerView.bounds.size)
        bottomLeftCornerView.frame = CGRect.init(origin: CGPoint.init(x: gridRect.minX-bottomLeftCornerView.bounds.width/2, y: gridRect.maxY-bottomLeftCornerView.bounds.height/2), size: bottomLeftCornerView.bounds.size)
        bottomRightCornerView.frame = CGRect.init(origin: CGPoint.init(x: gridRect.maxX-bottomRightCornerView.bounds.width/2, y: gridRect.maxY-bottomRightCornerView.bounds.height/2), size: bottomRightCornerView.bounds.size)
        
        
        topEdgeView.frame = CGRect.init(x: topLeftCornerView.frame.maxX, y: gridRect.minY-topEdgeView.bounds.height/2, width: topRightCornerView.frame.minX-topLeftCornerView.frame.maxX, height: topEdgeView.bounds.height)
        leftEdgeView.frame = CGRect.init(x: gridRect.minX-leftEdgeView.bounds.width/2, y: topLeftCornerView.frame.maxY, width:leftEdgeView.bounds.width, height: bottomLeftCornerView.frame.minY-topLeftCornerView.frame.maxY)
        bottomEdgeView.frame = CGRect.init(x: bottomLeftCornerView.frame.maxX, y: gridRect.maxY-bottomEdgeView.bounds.height/2, width: bottomRightCornerView.frame.minX-bottomLeftCornerView.frame.maxX, height: bottomEdgeView.bounds.height)
        rightEdgeView.frame = CGRect.init(x: gridRect.maxX-rightEdgeView.bounds.width/2, y: topRightCornerView.frame.maxY, width:rightEdgeView.bounds.width, height: bottomRightCornerView.frame.minY-topRightCornerView.frame.maxY)
    }
    
    //返回正在调整网格大小时的网格区域
    private func cropRectMake(with resizeControlView: TSResizeControl) -> CGRect{
        var rect = gridRect
        if resizeControlView == topEdgeView {
            rect = CGRect.init(x: initialRect.minX, y: initialRect.minY+resizeControlView.translation.y, width: initialRect.width, height: initialRect.height-resizeControlView.translation.y)
        }else if resizeControlView == leftEdgeView{
            rect = CGRect.init(x: initialRect.minX+resizeControlView.translation.x, y: initialRect.minY, width: initialRect.width-resizeControlView.translation.x, height: initialRect.height)
        }else if resizeControlView == bottomEdgeView{
            rect = CGRect.init(x: initialRect.minX, y: initialRect.minY, width: initialRect.width, height: initialRect.height+resizeControlView.translation.y)
        }else if resizeControlView == rightEdgeView{
            rect = CGRect.init(x: initialRect.minX, y: initialRect.minY, width: initialRect.width+resizeControlView.translation.x, height: initialRect.height)
        }else if resizeControlView == topLeftCornerView{
            rect = CGRect.init(x: initialRect.minX+resizeControlView.translation.x, y: initialRect.minY+resizeControlView.translation.y, width: initialRect.width-resizeControlView.translation.x, height: initialRect.height-resizeControlView.translation.y)
        }else if resizeControlView == topRightCornerView{
            rect = CGRect.init(x: initialRect.minX, y: initialRect.minY+resizeControlView.translation.y, width: initialRect.width+resizeControlView.translation.x, height: initialRect.height-resizeControlView.translation.y)
        }else if resizeControlView == bottomLeftCornerView{
            rect = CGRect.init(x: initialRect.minX+resizeControlView.translation.x, y: initialRect.minY, width: initialRect.width-resizeControlView.translation.x, height: initialRect.height+resizeControlView.translation.y)
        }else if resizeControlView == bottomRightCornerView{
            rect = CGRect.init(x: initialRect.minX, y: initialRect.minY, width: initialRect.width+resizeControlView.translation.x, height: initialRect.height+resizeControlView.translation.y)
        }
        
        // 限制x/y 超出左上角 最大限度
        if ceil(rect.origin.x) < ceil(maxGridRect.minX) {
            rect.origin.x = maxGridRect.origin.x
            rect.size.width = initialRect.maxX - maxGridRect.origin.x
        }
        if ceil(rect.origin.y) < ceil(maxGridRect.minY) {
            rect.origin.y = maxGridRect.origin.y
            rect.size.height = initialRect.maxY - maxGridRect.origin.y
        }
        if ceil(rect.origin.x+rect.size.width)>maxGridRect.maxX {
            rect.size.width = maxGridRect.maxX-rect.minX
        }
        if ceil(rect.origin.y+rect.size.height)>maxGridRect.maxY {
            rect.size.height = maxGridRect.maxY-rect.minY
        }
        
        ///限制最小
        
        if ceil(rect.width) <= ceil(minGridSize.width) {
            rect.origin.x = initialRect.maxX-minGridSize.width
            rect.size.width = initialRect.maxX - maxGridRect.origin.x
        }
        
        
        return rect
    }
}


extension TSGridView: TSResizeControlDelegate{
    func resizeControlDidBeginResizing(_ resizeControl: TSResizeControl) {
        initialRect = gridRect
        showMaskLayer = false
    }
    
    func resizeControlDidResizing(_ resizeControl: TSResizeControl) {
        let rect = cropRectMake(with: resizeControl)
        setGridRect(rect, isMaskLayer: true)
    }
    
    func resizeControlDidEndResizing(_ resizeControl: TSResizeControl) {
        showMaskLayer = true
    }
    
}
