//
//  TSCameraViewController.swift
//  TSCamera_Example
//
//  Created by leetangsong on 2022/5/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
enum TSCameraType {
    case video
    case image
    case imageAndVideo
}

class TSCameraViewController: UIViewController {
   
    // 输入类型
    var inputType: TSCameraType = .image
    // 视频最大秒数
    var videoMaxLength: Double = 10
    //拍完视频或者照片的路径
    private var url: String?
    private var outputType: TSCameraType?
    
    var controlView: TSCameraControl!
    lazy var manager: TSCameraManager = TSCameraManager.init(superView: cameraContentView)
    lazy var cameraContentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale: CGFloat = 16.0 / 9.0
        let contentWidth = UIScreen.main.bounds.size.width
        let contentHeight = min(scale * contentWidth, UIScreen.main.bounds.size.height)
        
        cameraContentView.backgroundColor = UIColor.black
        cameraContentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: contentHeight)
        cameraContentView.center = self.view.center
        view.addSubview(cameraContentView)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.startRunning()
        manager.focusAt(cameraContentView.center)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        view.backgroundColor = UIColor.black
        cameraContentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(focus(_:))))
        cameraContentView.addGestureRecognizer(UIPinchGestureRecognizer.init(target: self, action: #selector(pinch(_:))))
        controlView = TSCameraControl.init(frame: CGRect(x: 0, y: cameraContentView.ts.height - 150, width: self.view.ts.width, height: 150))
        controlView.delegate = self
        controlView.videoLength = self.videoMaxLength
        controlView.inputType = self.inputType
        cameraContentView.addSubview(controlView)
    }
    @objc func focus(_ ges: UITapGestureRecognizer) {
        let focusPoint = ges.location(in: cameraContentView)
        manager.focusAt(focusPoint)
    }
    
    @objc func pinch(_ ges: UIPinchGestureRecognizer) {
        guard ges.numberOfTouches == 2 else { return }
        if ges.state == .began {
            manager.repareForZoom()
        }
        manager.zoom(Double(ges.scale))
    }
}


extension TSCameraViewController: TSCameraControlDelegate {
    
    func cameraControlDidComplete() {

    }
    
    func cameraControlDidTakePhoto() {
//        manager.pickImage { [weak self] (imageUrl) in
//            guard let `self` = self else { return }
//            DispatchQueue.main.async {
//                self.type = .image
//                self.url = imageUrl
//                self.previewImageView.image = UIImage.init(contentsOfFile: imageUrl)
//                self.previewImageView.isHidden = false
//                self.controlView.showCompleteAnimation()
//            }
//        }
    }
    
    func cameraControlBeginTakeVideo() {
        manager.repareForZoom()
        manager.startRecordingVideo()
    }
    
    func cameraControlEndTakeVideo() {
//        manager.endRecordingVideo { [weak self] (videoUrl) in
//            guard let `self` = self else { return }
//            let url = URL.init(fileURLWithPath: videoUrl)
//            self.type = .video
//            self.url = videoUrl
//            self.videoPlayer.isHidden = false
//            self.videoPlayer.videoUrl = url
//            self.videoPlayer.play()
//            self.controlView.showCompleteAnimation()
//        }
    }
    
    func cameraControlDidChangeFocus(focus: Double) {
        let sh = Double(UIScreen.main.bounds.size.width) * 0.15
        let zoom = (focus / sh) + 1
        self.manager.zoom(zoom)
    }
    
    func cameraControlDidChangeCamera() {
        manager.changeCamera()
    }
    
    func cameraControlDidClickBack() {
//        self.previewImageView.isHidden = true
//        self.videoPlayer.isHidden = true
//        self.videoPlayer.pause()
    }
    
    func cameraControlDidExit() {
        dismiss(animated: true, completion: nil)
    }
    
}
