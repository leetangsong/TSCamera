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
        let button = UIButton()
        button.setTitle("go", for: .normal)
        button.backgroundColor = .red
        button.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        view.addSubview(button)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc func click(){
        self.present(TSCameraViewController(), animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

