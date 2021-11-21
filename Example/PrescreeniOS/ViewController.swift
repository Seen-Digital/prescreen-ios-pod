//
//  ViewController.swift
//  PrescreeniOS
//
//  Created by
//      - Verachad Wongsawangtham
//      - Thanapon Noraset
//  Copyright (c) 2021 Seen Digital. All rights reserved.
//

import UIKit
import AVFoundation
import PrescreeniOS

class ViewController: UIViewController {

    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Prescreen.shareInstance.initialize(apiKey: "68OvRGckCYiElYRqMqv7")
        configure()
    }

    override func viewWillDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper methods
    private func configure() {
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
            }
        }
        
        currentDevice = backFacingCamera
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {
            return
        }

        let output = AVCaptureVideoDataOutput()
        let queue = DispatchQueue(label: "myqueue")
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: queue)
        
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(output)
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        

        captureSession.startRunning()
        
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let result = Prescreen.shareInstance.scanIDCardSync(sampleBuffer: sampleBuffer, cameraPosition: self.currentDevice.position)
        if result.error != nil {
            print(result.error!)
        }
        else if (result.confidence >= 0.5) {
            print("Confidence: \(result.confidence)")
            print("Front side: \(result.isFrontSide)")
            print("Front side full: \(String(describing: result.isFrontCardFull))")
            if (result.texts != nil) {
                print(result.texts!)
            }
            if (result.isFrontCardFull == true) {
                // available if isFrontCardFull is true
                print(result.croppedImage)
                if (result.classificationResult?.error == nil) {
                    print(result.classificationResult?.mlConfidence)
                }
                
            }
        }
        // throttle the processing 0.4s
        do { usleep(400000) }
    }
}



