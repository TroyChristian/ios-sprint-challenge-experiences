//
//  VideoViewController.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import UIKit

protocol VideoViewControllerDelegate {
    func addVideoButtonTapped()
}



import UIKit
import AVFoundation
import CoreLocation

class VideoViewController: UIViewController {
    
    //MARK: // PROPERTIES
    var player: AVPlayer!
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var delegate: VideoViewControllerDelegate?
    var isRecording: Bool {
              fileOutput.isRecording
          }
    var customCoordinate:CLLocationCoordinate2D?
    
    //MARK: OUTLETS:
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    
    
    @IBOutlet weak var videoTitleTextField: UITextField!
    
    
    
    @IBOutlet weak var geoSwitch: UISwitch!
    
    
    @IBOutlet weak var geoSwitchLabel: UILabel!
    
    //MARK: ACTIONS:
    @IBAction func addVideoExperienceButtonTapped(_ sender: Any) {
        addVideo()
        
    }
    
   
    @IBAction func geoSwitchTapped(_ sender: Any) {
        chooseLocation()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoTitleTextField.delegate = self as? UITextFieldDelegate

        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpCamera()
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
        
//    func updateViews() {
//        recordButton.isSelected = fileOutput.isRecording
//    }
    
        func chooseLocation() {
            let alert = UIAlertController(title: "Custom Location", message: "Input the latitude and longitude of where your experience took place. Or press cancel to automatically use your current location", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Latitude: "})
            
            alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Longitude: "})
            
            alert.addAction(UIAlertAction(title: "Set Custom Location", style: .default, handler: { action in
                
                if let latitude = (alert.textFields?.first?.text) ,
                 let  longitude = (alert.textFields?[1].text) {
                 guard   let lat = CLLocationDegrees(latitude),
                    let  long = CLLocationDegrees(longitude) else {print( "Returning line 320.") ; return}
                   
                    print("322 \(lat), \(long)")
    //
                    
                    self.customCoordinate = LocationHelper.shared.getCustomLocation(latitude:lat ?? 33.3 , longitude: long ?? 33.3)
                    
                    
                   
                    
                } else { return }
            }))
            self.present(alert, animated:true, completion: nil)
        }
    
    
    private func updateViews() {
          guard isViewLoaded else { return }
          let isRecording = fileOutput.isRecording
          let recordButtonImage = isRecording ? "Stop" : "Record"
          recordButton.setImage(UIImage(named: recordButtonImage), for: .normal)
      }
        
    
    
    private func setUpCamera() {
        let camera = bestCamera()
        
        
        // configuration
        
        captureSession.beginConfiguration()
        
        // Inputs
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Device configured incorrectly")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Unable to add camera input")
            
        }
        
        captureSession.addInput(cameraInput)
        
        
        // 1920x1080p
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Microphone
        
        
        
        
        // Outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot add file output")
        }
        
        captureSession.addOutput(fileOutput)
        
        
        
        
        
        // commit configuration
        
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
        
        
    }
    private func bestCamera() -> AVCaptureDevice {
        // front / back
        // wide angle, ultra wide angle, depth, zoom lens
        // try ultra wide lens
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        // try wide angle lens
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        fatalError("No cameras available on the device (or you're using a simulator)")
    }

// I am going to move this up to the top, but really dont want to break the storyboard right now. 
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecord()
      

    }
    
    func toggleRecord() {
        if isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
        
    }
    /// Creates a new file URL in the documents directory
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    func playVideo(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cameraView.frame
        playerLayer.videoGravity = .resize
        view.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    func addVideo() {
        view.endEditing(true)
        
        guard let title = videoTitleTextField.text, !title.isEmpty else {
            presentInformationalAlertController(title: "Title Required", message: "Video Experiences require a title.")
            return
        }
        
        if geoSwitch.isOn {
            
                if customCoordinate != nil {
                               
                               ExperienceController.shared.createExperience(title: title, mediaType: .image, geotag: customCoordinate)
                               print("Executed in the block that see's customCoordinate is not nil")
                               
                               self.navigationController?.popToRootViewController(animated: true)
                               return
                }
            LocationHelper.shared.getCurrentLocation { (coordinate) in
                ExperienceController.shared.createExperience(title: title, mediaType: .video, geotag: coordinate)
                
                self.delegate?.addVideoButtonTapped()
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
             ExperienceController.shared.createExperience(title: title, mediaType: .video, geotag: nil)
            self.delegate?.addVideoButtonTapped()
             self.navigationController?.popToRootViewController(animated: true)
            
            
            
        }
        
        
    }
    
    


}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
       
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving recording: \(error)")
        }
        print("Url: \(outputFileURL.path)")
        updateViews()
         playVideo(url:outputFileURL)
        
    }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             textField.resignFirstResponder()
             return true
         }
}



    

   


