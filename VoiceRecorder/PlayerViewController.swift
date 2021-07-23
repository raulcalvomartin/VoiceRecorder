//
//  PlayerViewController.swift
//  VoiceRecorder
//
//  Created by raul_builder on 10.07.2021.
//

import UIKit
import AVFoundation


class PlayerViewController: UIViewController, AVAudioPlayerDelegate {
    var recordedAudioUrl: URL!

    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.recordedAudioUrl ?? "No value")
        setupAudio()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func play(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
          case .slow:
              playSound(rate: 0.5)
          case .fast:
              playSound(rate: 1.5)
          case .chipmunk:
              playSound(pitch: 1000)
          case .vader:
              playSound(pitch: -1000)
          case .echo:
              playSound(echo: true)
          case .reverb:
              playSound(reverb: true)
          }

          configureUI(true)
    }
    
    @IBAction func stop(_ sender: UIButton) {
        stopAudio()
    }

}
