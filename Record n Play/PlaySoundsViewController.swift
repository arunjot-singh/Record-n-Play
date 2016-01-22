//
//  PlaySoundsViewController.swift
//  Record n Play
//
//  Created by Arunjot Singh on 1/22/16.
//  Copyright © 2016 Arunjot Singh. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var StopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        do {
        //        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
        //            let filePathUrl = try NSURL.fileURLWithPath(filePath)
        //
        //        } else{
        //            print("File path is empty")}
        //        } catch let error as NSError {
        //            print("something bad happened")
        //            print(error.description)
        //        }
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        StopButton.hidden = true
    }
    
    @IBAction func SlowPlay(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.play()
        StopButton.hidden = false
        audioEngine.stop()
        audioEngine.reset()
    }
    @IBAction func FastPlay(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.play()
        StopButton.hidden = false
        audioEngine.stop()
        audioEngine.reset()
    }
    @IBAction func ChipmunkPlay(sender: UIButton) {
        audioPlayer.stop()
        playAudioWithVariablePitch(1000)
        StopButton.hidden = false
        
    }
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func darthVaderPlay(sender: UIButton) {
        audioPlayer.stop()
        playAudioWithVariablePitch(-1000)
        StopButton.hidden = false
    }
    @IBAction func RecordAgain(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        StopButton.hidden = true
    }
    
    @IBAction func StopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        StopButton.hidden = true
    }
}
