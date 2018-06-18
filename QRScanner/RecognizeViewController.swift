//
//  ViewController.swift
//  QRScanner
//
//  Created by Nghia Nguyen on 6/16/18.
//  Copyright © 2018 Nghia Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class RecognizeViewController: UIViewController {

    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isShowingResult = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        if initCamera() {
            setMetadataOutput()
            addCameraLayer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func initCamera() -> Bool {
        guard let captureDevice = AVCaptureDevice.default(for: .video)  else {
            print("Failed to get the camera device")
            return false
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                return true
            }
        } catch {
            print("\(error)")
        }
        return false
    }
    
    func setMetadataOutput() {
        let captureMetadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            captureMetadataOutput.metadataObjectTypes = UtilsFunction.getListObjectTypeSupported()
        }
    }
    
    func addCameraLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
    }
    
    func showResult(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler: { [unowned self] (action) in
            UIPasteboard.general.string = message
            self.view.makeToast("Copied")
            self.isShowingResult = false
        })
        alertVC.addAction(copyAction)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [unowned self] _ in
            self.isShowingResult = false
        }))
        alertVC.preferredAction = copyAction
        present(alertVC, animated: true, completion: nil)
    }
    
    func processData(data: AVMetadataMachineReadableCodeObject) {
        if data.stringValue != nil {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            isShowingResult = true
            let barcodeType = UtilsFunction.getObjectTypeName(type: data.type)
            showResult(title: barcodeType, message: data.stringValue!)
        }
    }
}

extension RecognizeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if isShowingResult {
            return
        }
        guard metadataObjects.count > 0, let metaDataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            return
        }
        processData(data: metaDataObj)
    }
}

