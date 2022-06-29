//
//  TSCameraViewController.swift
//  TSCamera_Example
//
//  Created by leetangsong on 2022/5/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import TSHandyKit
import GPUImage

enum TSCameraType {
    case video
    case image
    case imageAndVideo
}

class TSCameraViewController: UIViewController {
   
    // 输入类型
    var inputType: TSCameraType = .imageAndVideo
    // 视频最大秒数
    var videoMaxLength: Double = 10
    //拍完视频或者照片的路径
    private var url: String?
    private var outputType: TSCameraType?
    
    var controlView: TSCameraControl!
    lazy var manager: TSCameraManager = TSCameraManager.init(superView: cameraContentView)
    lazy var cameraContentView = UIView()
    lazy var changeCameraButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale: CGFloat = 16.0 / 9.0
        let contentWidth = UIScreen.main.bounds.size.width
        let contentHeight = min(scale * contentWidth, UIScreen.main.bounds.size.height)
        
        cameraContentView.backgroundColor = UIColor.black
        cameraContentView.frame = CGRect(x: 0, y: TSApp.naviBarHeight, width: contentWidth, height: contentHeight)
        view.addSubview(cameraContentView)
        setupView()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        changeCameraButton.setImage(UIImage.ts.image(fromCameraResource: "change_camera"), for: .normal)
        changeCameraButton.frame = CGRect(x: 0, y: TSApp.statusBarHeight, width: 44, height: 44)
        changeCameraButton.addTarget(self, action: #selector(changeCameraButtonClick), for: .touchUpInside)
        view.addSubview(changeCameraButton)
        changeCameraButton.ts.right = 10
        cameraContentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(focus(_:))))
        cameraContentView.addGestureRecognizer(UIPinchGestureRecognizer.init(target: self, action: #selector(pinch(_:))))
        controlView = TSCameraControl.init(frame: CGRect(x: 0, y: view.frame.height-18-150, width: self.view.ts.width, height: 150))
        controlView.delegate = self
        controlView.videoLength = self.videoMaxLength
        controlView.inputType = self.inputType
        view.addSubview(controlView)
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        label.isHidden = true
        if inputType == .video || inputType == .imageAndVideo{
            if inputType == .video {
                label.text = "轻触拍照"
            }else{
                label.text = "轻触拍照，按住摄像"
            }
            label.sizeToFit()
            label.center = CGPoint.init(x: view.frame.size.width/2, y: controlView.frame.minY)
            label.layer.shadowColor = UIColor.black.cgColor
            label.layer.shadowOpacity = 1
            label.layer.shadowOffset  = CGSize.init(width: 0, height: 1)
            label.layer.shadowRadius = 3
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                label.isHidden = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                UIView.animate(withDuration: 0.25) {
                    label.alpha = 0
                } completion: { _ in
                    label.removeFromSuperview()
                }
            }
        }
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
    @objc func changeCameraButtonClick(){
        manager.changeCamera()
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
        manager.endRecordingVideo { [weak self] (videoUrl) in
           
        }
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
