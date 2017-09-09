//
//  CameraManager.swift
//  StoringSnapshots
//
//  Created by Geoff Glaeser on 9/8/17.
//  Copyright © 2017 Workoutaholic. All rights reserved.
//

import Foundation
import Photos

protocol CameraManagerDelegate {
    func cameraDidTakePhoto(img: NSData)
}

class CameraManager: NSObject, AVCapturePhotoCaptureDelegate {
    
    let captureSession = AVCaptureSession() // session manages the device(s) ->Input and pics taken -> output
    var cameraOutput: AVCapturePhotoOutput!
    var captureDevice: AVCaptureDevice? //the actual device
    var delegate: CameraManagerDelegate!
    
    init(delegate: CameraManagerDelegate) {
        self.delegate = delegate
    }
    
    func setUpCamera() {
        
        captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
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
    
    func snapPhoto() {
        
        guard let cameraAuthStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) as AVAuthorizationStatus?,
            cameraAuthStatus == .authorized else {
                print("no camera access")
                return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        
        cameraOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
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
        
        /*guard let dataOfImage = UIImage(data: dataImage) as UIImage? else {
            print("unable to convert to UIImage")
            return
        }*/
        
        delegate.cameraDidTakePhoto(img: dataImage as NSData)
        
        
    }
    
    deinit {
        captureSession.stopRunning()
    }
    
}
