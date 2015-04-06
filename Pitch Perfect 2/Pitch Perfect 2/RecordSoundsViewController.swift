//
//  RecordSoundsViewController.swift
//  Pitch Perfect 2
//
//  Created by Yu Sun on 3/19/15.
//  Copyright (c) 2015 Yu Sun. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //make RecordSoundViewController a delegate of AVAudioRecorder
    
    @IBOutlet weak var recordButton: UIButton! //establish connection for record button
    @IBOutlet weak var tapToRecordLabel: UILabel! //add a tap to record label give UX hints
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        //initial setup
        super.viewDidLoad()
    }
    

    @IBOutlet weak var recordingInProgress: UILabel! //establish a connection for recording label
    @IBOutlet weak var stopButton: UIButton!     //establish a connection for stop button

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //create to inherit from and override UIViewController's viewWillAppear
        //Best practice: show and hide things
        stopButton.hidden = true //hide the stop button
        recordButton.enabled = true //enable recording button
    }

    @IBAction func recordAudio(sender: UIButton) {
        // code to run upon clicking record button

        recordButton.enabled = false // disable recording button
        tapToRecordLabel.hidden = true //hide tap to record label
        recordingInProgress.hidden = false // show previously hidden recording label
        stopButton.hidden = false // show stop button
        
        //Find path where our app is allowed to store
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //Use date time as file name
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        // store directory path and file name into a variable called pathArray
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray) //output an NSURL create a filePath
        //end of creating a filePath
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        //make RSVC delegate of AVAudioRecorder allows access to audioRecorderDidFinishRecording() of AVAudioRecorder
        audioRecorder.delegate = self // audioRecorder's new delegate is itself ... the RecordSoundsViewController
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //AVAudioRecorder indicates that recording and processing is completed
        //invoked when audio finished recording, not explicitly called in our controller, very cool!
        // a part of AVAudioRecorder
        if(flag){
            //initialize our model object
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent) //initiate model class passing in URL NSURL and title string
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio) //performSegue helps pass files from 1 scene to another (one controller to another). stopRecording is the name of the segue
        }else{
            //error output to console
            //user won't receive a message yet
            println("Recording was not successful") //record button renabled
            recordButton.enabled = true
            stopButton.hidden = true
        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // right before the segue happens great place to pass data
        if (segue.identifier == "stopRecording"){
            //name of the segue is stopRecording
            // get the destination controller and store it
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            // get data from the sender parameter
            let data = sender as RecordedAudio
            // store data in global variable receiveAudio initiated from model data structure defined in RecordAudio.swift
            playSoundsVC.receiveAudio = data
        }
    }
    
    
    
    @IBAction func stopRecording(sender: UIButton) {
        //Udacity lecture stopAudio
        //this is a button and click event which is different from the stopRecording segue
        recordingInProgress.hidden = true //hide label
        audioRecorder.stop()
        tapToRecordLabel.hidden = false //show label
        //manages an audio session
        //manage competing audio demands
        var audioSession = AVAudioSession.sharedInstance() //getting shared instance
        audioSession.setActive(false, error: nil) //activates session
    }

}

