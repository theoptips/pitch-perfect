//
//  PlaySoundsViewController.swift
//  Pitch Perfect 2
//
//  Created by Yu Sun on 3/30/15.
//  Copyright (c) 2015 Yu Sun. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    //declaring global variables
    var audioPlayer:AVAudioPlayer!
    // pass files between RecordSoundsViewController and PlaySoundsViewController
    var receiveAudio:RecordedAudio! //as defined in RecordedAudio.swift
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile! //for scheduleFile
    @IBOutlet weak var stopAudioButton: UIButton!
    
    override func viewDidLoad() {
        //initial setup
        super.viewDidLoad()
        //initiating audioPlayer an instance of AVAudioPlayer
        audioPlayer = AVAudioPlayer(contentsOfURL: receiveAudio.filePathUrl, error: nil) //AVAudioPlayer returns no error, takes in an NSURL
        audioPlayer.enableRate = true //enable rate property
        audioEngine = AVAudioEngine() //initialized for using AVAudioUnitTimePitch() to change pitch
        audioFile = AVAudioFile(forReading: receiveAudio.filePathUrl, error: nil) //turn NSURL to AVAudioFile type
        }
    
    @IBOutlet weak var slowSnailPlay: UIButton!
    
    func cleanAudioStopHelper(){
        //refactor codes for stop audio player and engine
        //best practice for clean stop
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioSetRate(rate:Float){
        // refactored codes for snail and bunny playback
        // .rate property controls speed, normal value 1.0, double is 2.0, half is 0.5
        // prevent audioEngine play and audioPlayer overlap, e.g. prevent chipmunk and bunny playback overlap
        cleanAudioStopHelper()
        stopAudioButton.hidden = false; //show stop button
        audioPlayer.currentTime = 0.0 //best practice: reset start time
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    
    @IBAction func slowSnailPlay(sender: UIButton) {
        //This is playSlowAudio in the Udacity lecture
        playAudioSetRate(0.5)
        
    }
    
    
    @IBAction func fastRabbitPlay(sender: AnyObject) {
        //Udacity lecture playFastAudio
        playAudioSetRate(2)
    }
    


    

    override func viewWillAppear(animated: Bool) {
        stopAudioButton.hidden = true; //hide stop button
    }
    
    @IBAction func stopAudioButton(sender: UIButton) {
        //Udacity lecture stopAudio
        //stop any audio play for a clean stop
        cleanAudioStopHelper()

        //hide stop button
        stopAudioButton.hidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithVariablePitch(pitch:Float){
        // our function for changing audio pitch
        
        stopAudioButton.hidden = false; //show stop button
        
        cleanAudioStopHelper()
        
        var audioPlayerNode = AVAudioPlayerNode() //AVAudioPlayerNode connects to the audio file
        audioEngine.attachNode(audioPlayerNode)
        var changePitchEffect = AVAudioUnitTimePitch() //init an instance of AVAudioUnitTimePitch() a swift class allows changing audio pitch
        changePitchEffect.pitch = pitch //property default = 1.0, range -2400 to +2400
        audioEngine.attachNode(changePitchEffect)
        
        //connect the nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil) //connect to output like a speaker
        
        //play the audio
        //scheduleFile takes an AVAudioFile
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
        
    }

    
    @IBAction func playChimpmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000) //high pitch
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000) //low pitch
    }
}
