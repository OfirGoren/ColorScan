

/*
 Sources:
 
 1)https://developer.apple.com/documentation/avfoundation/capture_setup/setting_up_a_capture_session
 
 2)https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/04_MediaCapture.html#//apple_ref/doc/uid/TP40010188-CH5-SW14
 */

import Foundation
import AVFoundation
import UIKit

class LiveCameraHandler:NSObject {
    
    typealias MostDominantColorsClousre = (([DominantColor])->Void)
    
    static let shared = LiveCameraHandler()
    
    let captureSesstion = AVCaptureSession()
    private let dataOutput = AVCaptureVideoDataOutput()
    private let queue = DispatchQueue(label: "capture")
    private var videoDevice: AVCaptureDevice?
    private var fiveMostDominantColorsCallBack:MostDominantColorsClousre?
    
    
    private override init() {
        super.init()
        self.setupVideoDevice()
        self.setupVideoDeviceInput()
        self.setupDataOutput()
        self.setupDelegate()
        
    }
    
    
    private func setupVideoDevice() {
        videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                              for: .video, position: .back)
    }
    
    
    private func setupVideoDeviceInput() {
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            self.captureSesstion.canAddInput(videoDeviceInput)
            captureSesstion.addInput(videoDeviceInput)
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func setupDelegate() {
        // when there is already camera permisstion
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            dataOutput.setSampleBufferDelegate(self, queue: queue)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (granted: Bool) in
                // when user accept camera permisstion
                if granted {
                    guard let self = self else {return}
                    self.dataOutput.setSampleBufferDelegate(self, queue: self.queue)
                }
            })
        }
        
    }
    
    private func setupDataOutput() {
        
        if captureSesstion.canAddOutput(dataOutput) {
            captureSesstion.addOutput(dataOutput)
            
        }
        captureSesstion.commitConfiguration()
        
    }
    
    
    func getMostFiveDominantColorsInImage(completion: @escaping MostDominantColorsClousre) {
        fiveMostDominantColorsCallBack = completion
        
    }
    
}

// MARK: SampleBufferDelegate methods
extension LiveCameraHandler:AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        var liveImage = sampleBuffer.convertToUImage()
        liveImage = liveImage.renderResizedImage(newWidth: CGFloat(50))
        let fiveMostDominantColor = DominantColorsHelper.getFiveMostDominantColorsInImage(for: liveImage)
        
        if let fiveMostDominantColorsCallBack {
            fiveMostDominantColorsCallBack(fiveMostDominantColor)
            
        }
    }
}







