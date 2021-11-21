# PrescreeniOS

[![CI Status](https://img.shields.io/travis/northanapon/PrescreeniOS.svg?style=flat)](https://travis-ci.org/northanapon/PrescreeniOS)
[![Version](https://img.shields.io/cocoapods/v/PrescreeniOS.svg?style=flat)](https://cocoapods.org/pods/PrescreeniOS)
[![License](https://img.shields.io/cocoapods/l/PrescreeniOS.svg?style=flat)](https://cocoapods.org/pods/PrescreeniOS)
[![Platform](https://img.shields.io/cocoapods/p/PrescreeniOS.svg?style=flat)](https://cocoapods.org/pods/PrescreeniOS)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### How-to

- Initialize Prescreen instance

  ```swift
  Prescreen.shareInstance.initialize(apiKey: "API_KEY")
  ```

- Use `AVCaptureVideoDataOutputSampleBufferDelegate` to pass the result to `scanIDCard` function

  ```swift
  extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        Prescreen.shareInstance.scanIDCard(sampleBuffer: sampleBuffer, cameraPosition: self.currentDevice.position) { result in
            if result.error != nil {
                print(result.error!)
            }
            else if (result.confidence >= 0.5) {
                print("Confidence: \(result.confidence)")
                print("Front side: \(result.isFrontSide)")
                if (result.texts != nil) {
                    print(result.texts!)
                }
            }
            // Handle result here
        }
    }
  }
  ```

- The `IDCardResult` object will consist of the following fields

  ```swift
  public struct IDCardResult {
    public var error: Error?
    public var confidence: Double
    public var isFrontSide: Bool
    public var texts: [TextResult]?
    public var fullImage: UIImage?
    public var croppedImage: UIImage?
    public var isFrontCardFull: Bool?
    public var classificationResult: IDCardClassificationResult?
  }
  ```

  - `error`: If the recognition is successful, the `error` will be null. In case of unsuccessful scan, the `error.errorMessage` will contain the problem of the recognition.
  - `isFrontSide`: A boolean flag indicates whether the scan found the front side (`true`) or back side (`false`) of the card ID.
  - `confidence`: A value between 0.0 to 1.0 (higher values mean more likely to be an ID card).
  - `texts`: A list of OCR results. An OCR result consists of `type` and `text`.
    - `type`: Type of information. Right now, PreScreen support 3 types
      - `ID`
      - `SERIAL_NUMBER`
      - `LASER_CODE`
    - `text`: OCR text based on the `type`.
  - `fullImage`: A bitmap image of the full frame used during scanning.
  - `croppedImage`: A bitmap image of the card. This is available if `isFrontSide` is `true`.
  - `isFrontCardFull`: A boolean flag indicates whether the scan found thr front side and the card is likely to be complete.
  - `classificationResult`: A result from ML classification.
    - `mlConfidence`: A float from 0.0 to 1.0 indicating the probability of an ID card.
    - `error`: A string, usually `nil` if no error.

### Full Example

```swift
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
        Prescreen.shareInstance.initialize(apiKey: "API_KEY")
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
```

## Requirements

## Installation

PrescreeniOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PrescreeniOS'
```

## Author

northanapon, nor.thanapon@gmail.com

## License

PrescreeniOS is available under the MIT license. See the LICENSE file for more info.
