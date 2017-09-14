//
//  KQRHelper
//
//  Copyright © 2017 Kenan Atmaca. All rights reserved.
//  kenanatmaca.com
//
//

import UIKit
import AVFoundation


class KQRHelper: NSObject {
    
    private var session:AVCaptureSession!
    private var previewLayer:AVCaptureVideoPreviewLayer!
    
    var result:String?
    var QRView:UIImageView!
    
    func generate(text:String) {
        
        let data = text.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
    
        if let outImg = filter?.outputImage {
           
            let scaleX = QRView.frame.size.width / outImg.extent.size.width
            let scaleY = QRView.frame.size.height / outImg.extent.size.height
            
            let trans = CGAffineTransform.init(scaleX: scaleX, y: scaleY)
            
            QRView.image = UIImage(ciImage: (filter?.outputImage?.applying(trans))!)
        }
    }
    
    func reader(to view:UIView) {
        
        session = AVCaptureSession()
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
            print(error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.zPosition = -1
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
}//

extension KQRHelper: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        result = nil
        
        guard metadataObjects != nil else {
            return
        }
        
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObjectTypeQRCode {
              result = object.stringValue
            }
        }
    }
}
