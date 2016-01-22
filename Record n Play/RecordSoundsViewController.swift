//
//  ViewController.swift
//  Record n Play
//
//  Created by Arunjot Singh on 1/21/16.
//  Copyright © 2016 Arunjot Singh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var RecordingInProgress: UILabel!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var touch2Record: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        StopButton.hidden = true
        RecordButton.enabled = true
        touch2Record.hidden = false
    }
    @IBAction func RecordAudio(sender: UIButton) {
        
        RecordingInProgress.hidden = false
        StopButton.hidden = false
        RecordButton.enabled = false
        touch2Record.hidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            audioRecorder = try AVAudioRecorder(URL: filePath!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch let error as NSError {
            print(error.description)
        }
        
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successful")
            RecordButton.enabled = true
            StopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func StopRecording(sender: UIButton) {
        RecordingInProgress.hidden = true
        RecordButton.enabled = true
        StopButton.hidden = true
        
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Couldn't stop")
        }
    }
}
