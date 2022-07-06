//
//  TSImageEditViewController.swift
//  TSCamera_Example
//
//  Created by leetangsong on 2022/5/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TSImageEditViewController: UIViewController {

    var image: UIImage!
    lazy var imageView: UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.frame = view.bounds
        imageView.image = UIImage.init(named: "test")
        
        let gridView = TSGridView.init(frame: view.bounds)
        gridView.gridRect = CGRect.init(x: 100, y: 150, width: 200, height: 400)
        view.addSubview(gridView)
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
