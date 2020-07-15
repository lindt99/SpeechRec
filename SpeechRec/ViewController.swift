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
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var startHat: UIImageView!
    @IBOutlet var buttonBG: UIView!
    
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
        buttonBG.layer.cornerRadius = 35
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
                StartButton.setTitle("Stop Recording", for: .normal)
            
        } else if isRecording == false {
                recognitionTask?.cancel()
                StartButton.setTitle("Start Recording", for: .normal)

            //stop processing audio
            audioEngine.inputNode.removeTap(onBus: 0)
            
                if modelPhrase == bestString{
                    
                    print("correct pronunciation")
                    
                    //change hat image
                    if (startHat.alpha > 0){
                        //delete orage hat if still visible
                        startHat.alpha = 0
                    } else {
                        
                    }
                    resultImage.image = UIImage(named: "hatgreenr")
                    
                    
//                    //test for changing a part of the phrase into green
//                    let greenString = NSMutableAttributedString(string: detectedTextLabel.text!)
//                    greenString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: 2, length: 5))
//                    detectedTextLabel.attributedText = greenString
                    
                } else{
                    
                    let (diffRange, diffString) = diff(modelPhrase, bestString)!
                    
                    //change hat image
                    if (startHat.alpha > 0){
                        //delete orage hat if still visible
                        startHat.alpha = 0
                    } else {
                        
                    }
                    resultImage.image = UIImage(named: "hatredr")
                    

                    let rangeLocation = diffRange.startIndex
                    let rangeLength = diffString.count



        //patterns for changing a part of the phrase into red
                    let redString = NSMutableAttributedString(string: detectedTextLabel.text!)
                    
                    //pattern 1
                    redString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: rangeLocation, length: rangeLength))
                    
                    //pattern 2
                    redString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: diffRange.startIndex, length: diffRange.endIndex - diffRange.startIndex))
                    detectedTextLabel.attributedText = redString
                    
                    
                    
        //for notes
                    //experimenting conversion of Range to NSRange
                    let originalString = bestString as NSString
                    
                    let range = originalString.range(of: diffString)
                    
                    
        //for debugging purposes
                    //function to find the type of the entered variable
                    func printType(_ value: Any) {
                        let t = type(of: value)
                        print("'\(value)' of type '\(t)'")
                    }
                    
                    print(range)
                    print(diffRange)
                    print("diffString: " + String(diffString))
                    print("rangeLocation:" + String(rangeLocation))
                    print("rangeLength:" + String(rangeLength))
                    print("wrong pronunciation")
                    printType(rangeLocation)
                    printType(rangeLength)
                }

        }
            

        

    }


}

