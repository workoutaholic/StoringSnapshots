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
    
    let captureSession = AVCaptureSession() // session manages the device(s) ->Input and pics taken -> output
    var cameraOutput: AVCapturePhotoOutput!
    var captureDevice: AVCaptureDevice? //the actual device

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCamera()
        
        let btn = BaseBtn(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        btn.setTitle("Take Photos", for: .normal)
        btn.addTarget(self, action: #selector(ViewController.takePhotosPressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(btn)
        btn.center = btn.superview!.center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpCamera() {
        
        self.captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
        if(captureDevice != nil){
            
            DispatchQueue.main.async(execute: { 
                print("building assets for capture")
                
                if self.captureSession.outputs.isEmpty {
                    self.cameraOutput = AVCapturePhotoOutput()
                    self.captureSession.addOutput(self.cameraOutput)
                }
                
                if self.captureSession.inputs.isEmpty {
                    do {
                        try self.captureSession.addInput(AVCaptureDeviceInput(device: self.captureDevice))
                    } catch {
                        //self.showNoCameraAccess()
                        print("error adding AVCaptureDevice as Input to captureSession")
                    }
    
                }
                
                self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
                self.captureSession.startRunning()
            })
        }
        else {
            print("no camera found")
        }
    }
    
    func takePhotosPressed(_ sender: UIButton) {
        
        guard let cameraAuthStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) as AVAuthorizationStatus?,
            cameraAuthStatus == .authorized else {
                print("no camera access")
                return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        
        cameraOutput.capturePhoto(with: photoSettings, delegate: self)
    }


}

extension ViewController: AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        guard error == nil else {
            print("Error in capture - \(String(describing: error?.localizedDescription))")
            return
        }
        
        guard let sampleBuffer = photoSampleBuffer,
            let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                
                print("unable to convert dataImage from captureOutput")
                return
        }
        
        //storing to library at the moment while determining encryption scheme
        if let dataOfImage = UIImage(data: dataImage) as UIImage? {
            UIImageWriteToSavedPhotosAlbum(dataOfImage, nil, nil, nil)
        }
        
        captureSession.stopRunning()
        
    }
}

