//
//  ViewController.swift
//  SampleOCR
//
//  Created by Nyghtwel on 7/9/18.
//  Copyright © 2018 Nyghtwel. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox.AudioServices
import Photos

class ViewController: UIViewController {
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var mainImg:UIImage?
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var btnOn = 1, btnOff = 0
    
    let messageLabel: UILabel = {
        let label = UILabel()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: UIFont(name: "Ubuntu-Bold", size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paragraph])
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    let instantTextButton: UIButton = {
        let btn = UIButton()
        btn.accessibilityLabel = "Instant Text"
        btn.setBackgroundImage(#imageLiteral(resourceName: "Live Text Icon"), for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        btn.addTarget(self, action: #selector(didTapInstantButton), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    let documentButton: UIButton = {
        let btn = UIButton()
        btn.accessibilityLabel = "Document Text"
        btn.setBackgroundImage(#imageLiteral(resourceName: "Document Text Icon"), for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        btn.addTarget(self, action: #selector(didTapDocumentButton), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    @objc func didTapInstantButton(sender: UIButton) {
        var attributedText: NSMutableAttributedString!
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        if sender.tag == btnOn {
            sender.setImage(#imageLiteral(resourceName: "Live Text Icon"), for: .normal)
            sender.tag = btnOff
            attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: UIFont(name: "Ubuntu-Bold", size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paragraph])
            messageLabel.backgroundColor = .clear
        } else {
            sender.setImage(#imageLiteral(resourceName: "Live Text Icon-2"), for: .normal)
            sender.tag = btnOn
            attributedText = NSMutableAttributedString(string: "Processing...", attributes: [NSAttributedStringKey.font: UIFont(name: "Ubuntu-Bold", size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paragraph])
            messageLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            capturePhoto()
        }
        messageLabel.attributedText = attributedText
    }
    
    @objc func didTapDocumentButton(sender: UIButton) {
        print("did tap document button")
        sender.tag = btnOn
        capturePhoto()
        
        
//        envision.documentText(image: self.mainImg!, apiKey: "AIzaSyBn0724N8H0wOh9CcHqnkIUof-1qdxAaUE") { (result) in
//            let vc = DocumentView()
//            vc.message = result[0]["description"].stringValue
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        // Call your ocr document function and then launch the vc inside the closure
//        TestOCRDocumentText() { message in
//            guard let message = message else { return }
//            let vc = DocumentView()
//            vc.message = message
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        let vc = DocumentView()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoCaptureSession()
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.documentButton.tag = btnOff
        self.instantTextButton.tag = btnOff
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupVideoCaptureSession() {
        var deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        if deviceDiscoverySession.devices.first == nil {
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        }
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            view.backgroundColor = .white
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            captureSession.addOutput(capturePhotoOutput!)
        } catch {
            print(error)
            return
        }
        
        // Setup videoPreviewLayer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture startRunning is a blocking call so must be in seperate queue
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    private func capturePhoto(){
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    private func setupViews() {
        let stackView = UIStackView(), instantContainerView = UIView(), documentContainerView = UIView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(instantContainerView)
        stackView.addArrangedSubview(documentContainerView)
        
        view.addSubview(stackView)
        view.addSubview(messageLabel)
        instantContainerView.addSubview(instantTextButton)
        documentContainerView.addSubview(documentButton)
        
        messageLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 335, height: 150)
        messageLabel.anchorCenterXToSuperview()
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 80)
        instantTextButton.anchorCenterXToSuperview()
        instantTextButton.anchorCenterYToSuperview()
        documentButton.anchorCenterYToSuperview()
        documentButton.anchorCenterXToSuperview()
    }
}

extension ViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage.init(data: imageData, scale: 1.0) else {
            print("Error in getting image")
            return
        }
        print("got image \(image)")
        if self.documentButton.tag == btnOn {
            print("btn tag is on")

                    envision.documentText(image: image, apiKey: "AIzaSyD7VUSGrDiboIV3NhByjnNKYxJcTbSoQl0") { (result) in
                        DispatchQueue.main.async {
                            let vc = DocumentView()
                            vc.message = result[0]["description"].stringValue
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                     
                    }
            self.documentButton.tag = btnOff
        }
        
        if self.instantTextButton.tag == btnOn {
            print("btn tag is on")
            envision.instantText(image: image, apiKey: "AIzaSyD7VUSGrDiboIV3NhByjnNKYxJcTbSoQl0") { (result) in
                DispatchQueue.main.async {
                    self.messageLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .center
                    let attributedText = NSMutableAttributedString(string: result[0]["description"].stringValue, attributes: [NSAttributedStringKey.font: UIFont(name: "Ubuntu-Bold", size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paragraph])
                    self.messageLabel.attributedText = attributedText
                    self.messageLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                    self.instantTextButton.tag = self.btnOff
                }
                }
            }
        
        }
}




