//
//  RecordSoundsViewController.swift
//  VoiceRecorder
//
//  Created by raul_builder on 08.07.2021.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    static let stopRecordingSegue = "stopRecording"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled = false
        recordingButton.isEnabled = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RecordSoundsViewController.stopRecordingSegue {
            let player = segue.destination as! PlayerViewController
            print(sender!, "sender")
            player.recordedAudioUrl = (sender as! URL)
        }
    }

    @IBAction func recordAudio(_ sender: Any) {
        configureUI(true)
        let url = createFileUrl()
        prepareAudioSession()
        print(url, "URL")
        try! audioRecorder = AVAudioRecorder(url: url, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        configureUI(false)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: RecordSoundsViewController.stopRecordingSegue, sender: recorder.url)
        } else {
            print("error recording")
        }
    }
    
    private func createFileUrl() -> URL {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileName = "\(UUID().uuidString).wav"
        return URL(string: [directoryPath, fileName].joined(separator: "/"))!
    }
    
    private func prepareAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
    }
    
    private func configureUI(_ isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to record"
        recordingButton.isEnabled = isRecording
        stopRecordingButton.isEnabled = isRecording
    }
}

