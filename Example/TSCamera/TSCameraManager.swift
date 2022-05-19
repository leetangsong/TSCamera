//
//  TSCameraManager.swift
//  TSCamera_Example
//
//  Created by leetangsong on 2022/5/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import TSHandyKit
import AVFoundation
class TSCameraManager: NSObject {
    let session = AVCaptureSession()
    /**视频输入设备*/
    var videoInput: AVCaptureDeviceInput!
    /**音频输入设备*/
    var audioInput: AVCaptureDeviceInput!
    /**预览图层*/
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var assetWriter: AVAssetWriter!
    /**音频写入*/
    var assetWriterAudioInput: AVAssetWriterInput!
    /**视频写入*/
    var assetWriterVideoInput: AVAssetWriterInput!
    
    /**视频输出*/
    var videoDataOut: AVCaptureVideoDataOutput!
    /**音频输出*/
    var audioDataOut: AVCaptureAudioDataOutput!
    /**照片输出*/
    var stillImageOutput: AVCaptureStillImageOutput!
    let focusImageView = UIImageView()
    
    var currentUrl: String!
    var showView: UIView!
    
    let videoQueue = DispatchQueue(label: "videoOutQueue")
    let voiceQueue = DispatchQueue(label: "voiceOutQueue")
    
    var isRecording: Bool = false
    var isFocusing: Bool = false
    var videoCurrentZoom: Double = 1.0
    
    let orientation = TSDeviceOrientation()
    var currentOrientation: UIInterfaceOrientation = .portrait
    
    var error: (String) -> () = {_ in }
    
    
    init(superView: UIView) {
        super.init()
        self.showView = superView
        
        setupCamera()
        setupView()
        
        // 开启手机方向监听
        orientation.startUpdates { [weak self] (orientation) in
            guard let `self` = self else { return }
            self.currentOrientation = orientation
        }
    }
    
    func startRunning() {
        DispatchQueue.global(qos: .default).async {
            self.session.startRunning()
        }
    }
    // 初始化相机
    func setupCamera() {
        if (session.canSetSessionPreset(.high)) {
            session.sessionPreset = .high
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = showView.layer.bounds
        showView.layer.addSublayer(previewLayer)
        
        //输入设备
        let devicesVideo = AVCaptureDevice.devices(for: .video)
        let devicesAudio = AVCaptureDevice.devices(for: .audio)
        
        guard let firstVideoDevice = devicesVideo.first,
            let firstAudioDevice = devicesAudio.first,
            let video = try? AVCaptureDeviceInput.init(device: firstVideoDevice),
            let audio = try? AVCaptureDeviceInput.init(device: firstAudioDevice)
            else {
                error("初始化相机失败")
                return
        }
        
        videoInput = video
        audioInput = audio
        
        //添加输入源
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        if session.canAddInput(audioInput) {
            session.addInput(audioInput)
        }
        
        //视频输出
        videoDataOut = AVCaptureVideoDataOutput()
        videoDataOut.alwaysDiscardsLateVideoFrames = true
        videoDataOut.setSampleBufferDelegate(self, queue: videoQueue)
        if session.canAddOutput(videoDataOut) {
            session.addOutput(videoDataOut)
        }
        
        //音频输出
        audioDataOut = AVCaptureAudioDataOutput()
        audioDataOut.setSampleBufferDelegate(self, queue: voiceQueue)
        if session.canAddOutput(audioDataOut) {
            session.addOutput(audioDataOut)
        }
        
        //图片输出
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
    }
    
    func setupView() {
        focusImageView.image = UIImage.ts.image(fromCameraResource: "sight_video_focus")
        focusImageView.frame = CGRect(origin: .zero, size: CGSize(width: 60, height: 60))
        focusImageView.isHidden = true
        showView.addSubview(focusImageView)
    }
}
extension TSCameraManager: AVCaptureVideoDataOutputSampleBufferDelegate{
    
}

extension TSCameraManager: AVCaptureAudioDataOutputSampleBufferDelegate{
    
}


extension TSKitClassWrapper where Base == UIImage{
    static func image(fromCameraResource name: String) -> UIImage?{
        let bundle = Bundle.ts.bundle(with: TSCameraViewController.self, name: "TSCameraResource")
        let imgName:String = name.appending("@2x")
        guard let imgPath = bundle?.path(forResource: imgName, ofType: "png") else { return nil }
        let image:UIImage? = UIImage.init(contentsOfFile: imgPath)
        return image
    }
    
}
