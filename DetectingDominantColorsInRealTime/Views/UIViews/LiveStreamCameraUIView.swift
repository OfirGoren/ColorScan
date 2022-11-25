
import Foundation
import UIKit
import AVFoundation
class LiveStreamCameraUIView:UIView {
    
    /*
     Resource:
     https://developer.apple.com/documentation/avfoundation/capture_setup/setting_up_a_capture_session
     */
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    
}

