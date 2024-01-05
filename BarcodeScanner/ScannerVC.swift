//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by ayush on 29/12/23.
//

import UIKit
import AVFoundation

enum CameraError: String {
    case InvalidDeviceInput = "Something is wrong with the camera. We are unable to capture the input."
    case InvalidScannedValue = "The value scanned is ont valid. This app only scans EAN-8 & EAN-13."
}

protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate!
    
    init(scannerDelegate: ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate.didSurface(error: .InvalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
//    func scanAgain(){
//        setupCameraSession()
//    }
    
    private func setupCameraSession(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else{
            scannerDelegate.didSurface(error: .InvalidDeviceInput)
            return
        }
        let videoInput: AVCaptureInput
        
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate.didSurface(error: .InvalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate.didSurface(error: .InvalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .qr]
        } else {
            scannerDelegate.didSurface(error: .InvalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let object = metadataObjects.first else {
            scannerDelegate.didSurface(error: .InvalidScannedValue)
            return
        }
        
        guard let machineReadableObjects = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate.didSurface(error: .InvalidScannedValue)
            return
        }
        
        guard let barcode = machineReadableObjects.stringValue else {
            scannerDelegate.didSurface(error: .InvalidScannedValue)
            return
        }
        
        captureSession.stopRunning()
        scannerDelegate?.didFind(barcode: barcode)
    }
}
