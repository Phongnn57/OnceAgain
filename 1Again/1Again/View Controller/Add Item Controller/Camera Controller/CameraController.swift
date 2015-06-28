//
//  CameraController.swift
//  1Again
//
//  Created by Nam Phong on 6/28/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraControllerDelegate {
    func getIemFromCameraControl(var item: ItemObject!)
}

class CameraController: BaseSubViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var videoPreviewView: UIView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    
    var delegate: CameraControllerDelegate!
    var item: ItemObject!
    var session: AVCaptureSession!
    var stillImageOutput: AVCaptureStillImageOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var effectiveScale: CGFloat!
    var begingestureScale: CGFloat!
    var effectiveTranslation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configAllImages()
    }
    
    func removeSubviewFromImageView(imageView: UIImageView!) {
        var subviews = imageView.subviews
        for view in subviews {
            if view.isKindOfClass(UIButton) {
                view.removeFromSuperview()
            }
        }
    }
    
    func configImageViewWithImage(image: UIImage!, tag: Int) {
        if tag == 1 {
            if image != nil {
                self.image1.image = image
                addDeleteButtonToImage(self.image1)
            }
            else {
                self.image1.image = UIImage(named: "image:camera-default.png")
                removeSubviewFromImageView(self.image1)
            }
        } else if tag == 2 {
            if image != nil {
                self.image2.image = image
                addDeleteButtonToImage(self.image2)
            }
            else {
                self.image2.image = UIImage(named: "image:camera-default.png")
                removeSubviewFromImageView(self.image2)
            }
        } else if tag == 3 {
            if image != nil {
                self.image3.image = image
                addDeleteButtonToImage(self.image3)
            }
            else {
                self.image3.image = UIImage(named: "image:camera-default.png")
                removeSubviewFromImageView(self.image3)
            }
        } else if tag == 4 {
            if image != nil {
                self.image4.image = image
                addDeleteButtonToImage(self.image4)
            }
            else {
                self.image4.image = UIImage(named: "image:camera-default.png")
                removeSubviewFromImageView(self.image4)
            }
        } else if tag == 5 {
            if image != nil {
                self.image5.image = image
                addDeleteButtonToImage(self.image5)
            }
            else {
                self.image5.image = UIImage(named: "image:camera-default.png")
                removeSubviewFromImageView(self.image5)
            }
        }
    }
    
    func configAllImages() {
        configImageViewWithImage(item.image1, tag: 1)
        configImageViewWithImage(item.image2, tag: 2)
        configImageViewWithImage(item.image3, tag: 3)
        configImageViewWithImage(item.image4, tag: 4)
        configImageViewWithImage(item.image5, tag: 5)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        var inputDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError!
        var deviceInput: AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(inputDevice, error: nil) as! AVCaptureDeviceInput
        
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
            
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        applyDefaults()
        
        var rootLayer: CALayer = self.videoPreviewView.layer
        rootLayer.masksToBounds = true
        var frame: CGRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 180)

        previewLayer.frame = frame
        
        var gesture = UIPinchGestureRecognizer(target: self, action: "handlePinchFrom:")
        gesture.delegate = self
        videoPreviewView.addGestureRecognizer(gesture)
        
        
        rootLayer.insertSublayer(previewLayer, atIndex: 0)
        
        stillImageOutput = AVCaptureStillImageOutput()
        var outputSetting = NSDictionary(objectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey)
        
        
        stillImageOutput.outputSettings = outputSetting as [NSObject : AnyObject]
        session.addOutput(stillImageOutput)
        session.startRunning()
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UIPinchGestureRecognizer) {
            begingestureScale = effectiveScale
        }
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view == videoPreviewView {
            return true
        }
        return false
    }
    
    func handlePinchFrom(recognizer: UIPinchGestureRecognizer) {
        var alltouchesAreOnpreviewlayer = true
        var numTouches = recognizer.numberOfTouches()
        for var i = 0; i < numTouches; ++i {
            var location = recognizer.locationOfTouch(i, inView: self.videoPreviewView)
            var convertedLocation = previewLayer.convertPoint(location, fromLayer: previewLayer.superlayer)
            if !previewLayer.containsPoint(convertedLocation) {
                alltouchesAreOnpreviewlayer = false
                break
            }
        }
        if alltouchesAreOnpreviewlayer {
            effectiveScale = begingestureScale * recognizer.scale
            makeAndApplytransform()
        }
        
    }
    
    func makeAndApplytransform() {
        if previewLayer.frame.size.width >= videoPreviewView.frame.size.width {
            var affinetransform = CGAffineTransformMakeTranslation(effectiveTranslation.x, effectiveTranslation.y)
            affinetransform = CGAffineTransformScale(affinetransform, effectiveScale, effectiveScale)
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            previewLayer.setAffineTransform(affinetransform)
            CATransaction.commit()
        } else {
            var bounds: CGRect = CGRectMake(0, 0, self.videoPreviewView.frame.size.width+10, self.videoPreviewView.frame.size.height)
            previewLayer.frame = bounds
        }
    }
    
    func applyDefaults() {
        effectiveScale = 1.0
        previewLayer.setAffineTransform(CGAffineTransformIdentity)
        effectiveTranslation = CGPointMake(0, 0)
        previewLayer.frame = videoPreviewView.layer.bounds
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        previewLayer.session.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneBtn(sender: AnyObject) {
        delegate.getIemFromCameraControl(item)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        var videoConnection: AVCaptureConnection!
        for item  in stillImageOutput.connections {
            var connection = item as! AVCaptureConnection
            for portObj in connection.inputPorts {
                var port = portObj as! AVCaptureInputPort
                
                if port.mediaType == AVMediaTypeVideo {
                    videoConnection = connection
                    break
                }
            }
            if (videoConnection != nil) {
                break
            }
        }
        
        stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer: CMSampleBufferRef!, error: NSError!) -> Void in
            if sampleBuffer != nil {
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                var image = UIImage(data: imageData)
                self.item.passToEmptyImageInOrderWithImage(image)
                self.configAllImages()
            }
        })
    }
    
    func addDeleteButtonToImage(imageView: UIImageView) {
        var btn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btn.frame = CGRectMake(-3, -3, 20, 20)
        btn.setImage(UIImage(named: "image:camera-delete.png"), forState: UIControlState.Normal)
        btn.layer.shadowColor = UIColor.blackColor().CGColor
        btn.layer.shadowOffset = CGSizeMake(0, 4)
        btn.layer.shadowOpacity = 0.3
        imageView.addSubview(btn)
        btn.addTarget(self, action: "removeDeleteButtonFromImage:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func removeDeleteButtonFromImage(sender: AnyObject) {
        var btn = sender as! UIButton
        var image = btn.superview as! UIImageView
        let tag = image.tag
        btn.removeFromSuperview()
        if tag == 1 {item.image1 = nil}
        if tag == 2 {item.image2 = nil}
        if tag == 3 {item.image3 = nil}
        if tag == 4 {item.image4 = nil}
        if tag == 5 {item.image5 = nil}
        
        item.reOrderImageList()
        configAllImages()
    }
}
