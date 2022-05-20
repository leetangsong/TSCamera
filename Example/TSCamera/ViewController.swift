//
//  ViewController.swift
//  TSCamera
//
//  Created by leetangsong on 05/19/2022.
//  Copyright (c) 2022 leetangsong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = TSCameraManager.init(superView: view)
        manager.startRunning()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

