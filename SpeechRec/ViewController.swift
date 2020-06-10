//
//  ViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2020/06/04.
//  Copyright © 2020 本田彩. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet var detectedText: UILabel!
    @IBOutlet var StartButton: UIButton!
    @IBOutlet var resultLabel: UILabel!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var tapCount = 0
    var modelPhrase = String("Turn right on the red light")
    var bestString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func recordAndRecognizeSpeech(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
            buffer, _ in self.request.append(buffer)
        }
        
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        
        guard let myRecognizer = SFSpeechRecognizer() else{
            return
        }
        if !myRecognizer.isAvailable{
            return
        }
        
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                self.bestString = result.bestTranscription.formattedString
                self.detectedText.text = self.bestString
                
            } else if let error = error {
                print(error)
            }
        })
    }
    
    @IBAction func startButton(_ sender: UIButton){
        
        tapCount+=1
        
            
            if tapCount%2 == 1{
                self.recordAndRecognizeSpeech()
                StartButton.setTitle("Stop", for: .normal)
            } else if tapCount%2 == 0{
                recognitionTask?.cancel()
                StartButton.setTitle("Start", for: .normal)
                tapCount = 0
                if modelPhrase == bestString{
                    print("correct pronunciation")
                    self.resultLabel.textColor = UIColor.green
                    self.resultLabel.text = String("Correct Pronunciation")
                } else{
                    print("wrong pronunciation")
                    self.resultLabel.textColor = UIColor.red
                    self.resultLabel.text = String("Wrong Pronunciation")
                }
            }
            
        

        

    }


}

