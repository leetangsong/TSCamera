//
//  TSImageZoomView.swift
//  TSCamera_Example
//
//  Created by leetangsong on 2022/7/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TSImageZoomView: UIScrollView {
    var image: UIImage!{
        didSet{
            imageView.image = image
        }
    }
    lazy var imageView: UIImageView = UIImageView()
    
    override var frame: CGRect{
        didSet{
            imageView.frame = bounds
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(imageView)
        clipsToBounds = false
        imageView.isUserInteractionEnabled = true
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        maximumZoomScale = CGFloat.infinity
        minimumZoomScale = 1
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
    }
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var inside = super.point(inside: point, with: event)
        if imageView.frame.contains(point) {
            inside = true
        }
        return inside
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TSImageZoomView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
