//
//  TSImageClipController.swift
//  TSCamera_Example
//
//  Created by leetangsong on 2022/7/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import TSHandyKit

private let KBottomMenuHeight: CGFloat = 100
private let KGridTopMargin: CGFloat = 40 + (TSApp.isIphoneX ? 20:0)
private let KGridBottomMargin: CGFloat = 20
private let KGridLRMargin: CGFloat = 20

class TSImageClipController: UIViewController {
    /// 进入页面动画过渡前最原始位置
    var animateStartFrame: CGRect = .zero
    
    var image: UIImage!
    lazy var zoomView: TSImageZoomView = {
        let view = TSImageZoomView.init(frame: view.bounds)
        view.backgroundColor = .black
        return view
    }()
    /// 裁剪原始位置区域
    private var originalRect: CGRect = .zero
    /// 最大裁剪区域
    private var maxGridRect: CGRect = .zero
    
    private lazy var gridView: TSGridView = TSGridView.init(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    
    private func setupUI(){
        view.addSubview(zoomView)
        zoomView.image = image
        view.addSubview(gridView)
        view.backgroundColor = .black
        maxGridRect = CGRect.init(x: KGridLRMargin, y: KGridTopMargin, width: view.frame.width - KGridLRMargin*2, height: view.frame.height - KGridTopMargin  - KGridBottomMargin - KBottomMenuHeight)
       
        var size = CGSize.init(width: view.frame.width - 2 * KGridLRMargin, height: (view.frame.width - 2 * KGridLRMargin)*image.size.height/image.size.width)
        
//        zoomView.frame = animateStartFrame
        
        UIView.animate(withDuration: 0.3) {
            if size.height>self.maxGridRect.height {
                size = CGSize.init(width: self.maxGridRect.height*(self.image.size.width/self.image.size.height), height: self.maxGridRect.height)
                self.zoomView.ts.size  = size
                self.zoomView.ts.top = KGridTopMargin
                self.zoomView.ts.centerX = self.view.frame.width/2
                
            }else{
                self.zoomView.ts.size  = size
                self.zoomView.center = CGPoint.init(x: self.view.frame.width/2, y: (self.view.frame.height-KBottomMenuHeight-KGridTopMargin-KGridTopMargin)/2)
            }
        }
        gridView.maxGridRect = maxGridRect
        gridView.gridRect = zoomView.frame
        gridView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseInOut) {
            self.gridView.alpha = 1
        }

        
    }
    

}
