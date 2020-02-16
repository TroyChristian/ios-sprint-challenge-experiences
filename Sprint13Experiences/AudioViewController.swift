//
//  AudioViewController.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioViewControllerDelegate {
    func addAudioButtonTapped() 
    
}



class AudioViewController: UIViewController {
    var delegate: AudioViewControllerDelegate?
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var recordingURL:URL?
    var timer: Timer?
    

    //@IBOutlet weak var audioVisualizer: AudioVisualizer!
    
    //MARK: OUTLETS
    
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    
    @IBOutlet weak var timeSlider: UISlider!
    
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        // NOTE: DateComponentFormatter is good for minutes/hours/seconds
        // DateComponentsFormatter is not good for milliseconds, use DateFormatter instead)
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use a font that won't jump around as values change
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                          weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
         loadAudio()
        updateViews()
        
    }
    
    deinit {
        stopTimer()
    }
    
    private func updateViews() {
        playButton.isSelected = isPlaying
        recordButton.isSelected = isRecording
        
        //update time (currentTime)
        let elapsedTime = audioPlayer?.currentTime ?? 0
        timeElapsedLabel.text = timeIntervalFormatter.string(from: elapsedTime)
        
        timeSlider.value = Float(elapsedTime)
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
        
        let timeRemaining = (audioPlayer?.duration ?? 0) - elapsedTime
        timeRemainingLabel.text = timeIntervalFormatter.string(from: timeRemaining)
    }
    
    
    // MARK: - Playback
    
    func loadAudio() {
        // app bundle is readonly folder
//     let soungURL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!//programmer error if this fails to load
        
        
//        audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL ?? <#default value#>) //FIXME: use better error handling
//        audioPlayer?.isMeteringEnabled = true
//        audioPlayer?.delegate = self
    }
    
  func startTimer() {
      // timers are automatically registered on run loop, so we need to cancel before adding a new one
    // call evrey 30 ms (10-30)
      stopTimer()
    timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { [weak self] (timer) in
        
        guard let self = self, let audioPlayer = self.audioPlayer else {return}
          self.updateViews()
        
        self.audioPlayer?.updateMeters()
//        self.audioVisualizer.addValue(decibelValue: audioPlayer.averagePower(forChannel: 0))
        
      })
  }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //what do i want to do?
     //pause it
     // valume
     // restart the audio
     // update the time/labels
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    func play() {
        audioPlayer?.play()
        startTimer()
        updateViews()
    }
    
    func pause() {
        audioPlayer?.pause()
        stopTimer()
        updateViews()
         
    }
    
    func playPause() {
        if isPlaying {
             pause()
        } else {
            play()
        }
    }
    
    
    
    // MARK: - Recording
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
 func startRecording() {
     recordingURL = makeNewRecordingURL()
     if let recordingURL = recordingURL {
         print("URL: \(recordingURL)")
         // 44.1 KHz = FM quality audio
         let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // FIXME: can fail
         audioRecorder = try! AVAudioRecorder(url: recordingURL, format: format) // FIXME: Deal with errors fatalError()
        
        audioRecorder?.record()
        audioRecorder?.delegate = self
        updateViews()
     }
 }
    
    func requestRecordPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                guard granted == true else {
                    fatalError("We need microphone access")
                }
                self.startRecording()
            }
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateViews()
    }
    
 func toggleRecording() {
     if isRecording {
        stopRecording()
     } else {
        requestRecordPermission()
     }
 }
    
 func makeNewRecordingURL() -> URL {
     let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
     let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
     let url = documents.appendingPathComponent(name).appendingPathExtension("caf")
     return url
 }
    
    // MARK: - Actions
    
    @IBAction func togglePlayback(_ sender: Any) {
        playPause()
        
    }
    
    @IBAction func updateCurrentTime(_ sender: UISlider) {
        
    }
    
    @IBAction func toggleRecording(_ sender: Any) {
        toggleRecording()
    }
}


extension AudioViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
        stopTimer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
    }
    
}

extension AudioViewController:AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            //update player to load the new file
            
            if let recordingURL = recordingURL {
                audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("AudioRecorder error: \(error)")
        }
    }
}
