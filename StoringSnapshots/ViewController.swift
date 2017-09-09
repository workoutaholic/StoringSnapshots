//
//  ViewController.swift
//  StoringSnapshots
//
//  Created by Geoff Glaeser on 9/8/17.
//  Copyright © 2017 Workoutaholic. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    lazy var photoMgr: CameraManager = CameraManager(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoMgr.setUpCamera()
        
        let btn = BaseBtn(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        btn.setTitle("Take Photos", for: .normal)
        btn.addTarget(self, action: #selector(ViewController.takePhotosPressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(btn)
        btn.center = btn.superview!.center
        
    }
    
    func takePhotosPressed(_ sender: UIButton) {
        
        
        
        for i in 0..<10 {
            
            let time = DispatchTime.now() + (Double(i) * 0.5)
            DispatchQueue.main.asyncAfter(deadline: time, execute: { [weak self] in
                    self?.photoMgr.snapPhoto()
            })
        }
        
    }
    
}

extension ViewController: CameraManagerDelegate {
    
    func cameraDidTakePhoto(img: UIImage) {
        
        //storing to library at the moment while determining encryption scheme
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
    }

}
