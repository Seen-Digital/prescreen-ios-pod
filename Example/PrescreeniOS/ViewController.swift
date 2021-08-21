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
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
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
        Prescreen.shareInstance.scanIDCard(sampleBuffer: sampleBuffer, cameraPosition: self.currentDevice.position) { result in
            if result.error != nil {
                print(result.error!)
            }
            if result.texts != nil {
                print("OCR: \(result.confidence)")
                print(result.texts!)
            }
            if result.detectionResult != nil {
                print("ML: \(result.detectionResult!.mlConfidence), BOX: \(result.detectionResult!.boxConfidence)")
            }
            // Handle result here
        }
    }
}


