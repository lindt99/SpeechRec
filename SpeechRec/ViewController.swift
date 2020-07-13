//
//  ViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2020/06/04.
//  Copyright © 2020 本田彩. All rights reserved.
//

import UIKit
import Speech
import Diff

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet var detectedTextLabel: UILabel!
    @IBOutlet var StartButton: UIButton!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var testLabel: UILabel!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording: Bool = false
    var modelPhrase = String("Hello world is the first step to coding")
    var bestString: String = ""
    
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
                self.detectedTextLabel.text = self.bestString
                
            } else if let error = error {
                print(error)
            }
        })
    }
    
    @IBAction func startButton(_ sender: UIButton){
        
        isRecording.toggle()
                
        if isRecording == true {
            
                self.recordAndRecognizeSpeech()
                StartButton.setTitle("Stop", for: .normal)
            
        } else if isRecording == false {
                recognitionTask?.cancel()
                StartButton.setTitle("Start", for: .normal)

            //stop processing audio
            audioEngine.inputNode.removeTap(onBus: 0)
            
                if modelPhrase == bestString{
                    
                    print("correct pronunciation")
                    
                    //change result label's text and color
                    self.resultLabel.textColor = UIColor.green
                    self.resultLabel.text = String("Correct Pronunciation")
                    
                    //test for changing a part of the phrase into green
                    var greenString = NSMutableAttributedString(string: detectedTextLabel.text!)
                    greenString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: 2, length: 5))
                    detectedTextLabel.attributedText = greenString
                    
                } else{
                    
                    var (diffRange, diffString) = diff(modelPhrase, bestString)!
                    
                    //BELOW IS NOT WORKING
                    //var diffRangeNS = diffRange as NSString

                    var rangeLocation = diffRange.startIndex
                    var rangeLength = diffString.count
                    
                    
                    print("rangeLocation:" + String(rangeLocation))
                    print("rangeLength:" + String(rangeLength))
                    
                    //var redString = NSMutableAttributedString(string: detectedTextLabel.text!)
                    //redString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 15, length: 3))


                    //function to find the type of the entered variable
                    func printType(_ value: Any) {
                        let t = type(of: value)
                        print("'\(value)' of type '\(t)'")
                    }
                    
                    printType(rangeLocation)
                    printType(rangeLength)
                    print("wrong pronunciation")
                    
//                    //change result label's text and color
//                    self.resultLabel.textColor = UIColor.red
//                    self.resultLabel.text = String("Wrong Pronunciation")
//                    var difference = zip(modelPhrase, bestString).filter{$0 != $1}
//                    print(difference)
//
//                    //test for changing a part of the phrase into red
                    var redString = NSMutableAttributedString(string: detectedTextLabel.text!)
                    redString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: rangeLocation, length: rangeLength))
                    detectedTextLabel.attributedText = redString
                    
                }

        }
            

        

    }


}

