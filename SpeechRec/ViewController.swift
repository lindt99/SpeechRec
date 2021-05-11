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
import Parse

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet var detectedTextLabel: UILabel!
    @IBOutlet var StartButton: UIButton!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var startHat: UIImageView!
    @IBOutlet var buttonBG: UIView!
    
    @IBOutlet var testLabel: UILabel!
    
    @IBOutlet var questionLabel: UILabel!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording: Bool = false
    var modelPhrase = String("Hello world is the first step to coding")
    var bestString: String = ""
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    var gameModels = [Question]()
    var currentQ: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonBG.layer.cornerRadius = 35
        setupQuestionsW1()
        configureUI(question: gameModels.first!)
    }
    
    private func setupQuestionsW1(){
        gameModels.append(Question(modelPhrase: "I love the bread from Greece", qNum: 1))
        gameModels.append(Question(modelPhrase: "I'll take the lobster", qNum: 2))
        gameModels.append(Question(modelPhrase: "I'd like to be a millionaire", qNum: 3))
        gameModels.append(Question(modelPhrase: "He worked as a volunteer", qNum: 4))
        gameModels.append(Question(modelPhrase: "I love going to the bookstore", qNum: 5))
        gameModels.append(Question(modelPhrase: "I read the brochure", qNum: 6))
        gameModels.append(Question(modelPhrase: "I'm scared to fly in an airplane", qNum: 7))
        gameModels.append(Question(modelPhrase: "Hurry up or we'll miss the bus", qNum: 8))
        gameModels.append(Question(modelPhrase: "I hate horror movies", qNum: 9))
        gameModels.append(Question(modelPhrase: "Please take care of my cat", qNum: 10))
        gameModels.append(Question(modelPhrase: "Shall we drive or go by train?", qNum:11))
        gameModels.append(Question(modelPhrase: "She plays the viola really well", qNum: 12))
        gameModels.append(Question(modelPhrase: "Can you wrap that bracelet around my wrist?", qNum: 13))
        gameModels.append(Question(modelPhrase: "Rob reads reports before running", qNum: 14))
        gameModels.append(Question(modelPhrase: "I drew a picture of a frog in art class", qNum: 15))
        gameModels.append(Question(modelPhrase: "I had a French breakfast in Switzerland", qNum: 16))
        gameModels.append(Question(modelPhrase: "That crazy dragonfly took my pretzel", qNum: 17))
        gameModels.append(Question(modelPhrase: "I went to visit the aquarium in January", qNum: 18))
        gameModels.append(Question(modelPhrase: "The air feels really hot upstairs", qNum: 19))
        gameModels.append(Question(modelPhrase: "I unluckily had a flat tire on the way here", qNum: 20))
    }
    
    private func configureUI(question: Question){
        questionLabel.text = question.modelPhrase
    }
    
    struct Question{
        let modelPhrase: String
        let qNum: Int
        
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
    
    func checkRight(question:Question){

                
                isRecording.toggle()
                        
                if isRecording == true {
                    
                        self.recordAndRecognizeSpeech()
                        StartButton.setTitle("Stop", for: .normal)
                    
                } else if isRecording == false {
                        recognitionTask?.cancel()
                        StartButton.setTitle("Start", for: .normal)

                    //stop processing audio
                    audioEngine.inputNode.removeTap(onBus: 0)
                    
                    if question.modelPhrase == bestString{
                            
                            print("correct pronunciation")
                            
                        currentQ += 1
                            
                            //change hat image
                            if (startHat.alpha > 0){
                                //delete orage hat if still visible
                                startHat.alpha = 0
                            } else {
                                
                            }
                            resultImage.image = UIImage(named: "hatgreenr")
                            

                            
                            var result = PFObject(className:"Results")
                            result["uuid"] = uuid
                            result["answer"] = "correct"
                            result["spokenPhrase"] = bestString
                            result.saveInBackground {
                              (success: Bool, error: Error?) in
                              if (success) {
                                // The object has been saved.
                              } else {
                                // There was a problem, check error.description
                              }
                            }
                            
                            
                        } else{
                        
                            currentQ += 1
                            
        //                    let (diffRange, diffString) = diff(modelPhrase, bestString)!
                            
                            //change hat image
                            if (startHat.alpha > 0){
                                //delete orange hat if still visible
                                startHat.alpha = 0
                            } else {
                                
                            }
                            resultImage.image = UIImage(named: "hatredr")
                            
                        let modelarr:[String] = question.modelPhrase.components(separatedBy: " ")
                            let voicearr:[String] = bestString.components(separatedBy: " ")
                            
                            let voicearrlength = voicearr.count - 1
                            
                            //ordered collection diffing
                            let diff = voicearr.difference(from: modelarr)
                            
                            var word:[NSAttributedString] = []
                            
                            for voicearrword in 0...voicearrlength{
                                word.append(NSAttributedString(string: (voicearr[voicearrword])))
                                //print("voicearrword: " + String(voicearrword) + "voicearrklen: " + String(voicearrlength) )
                            }
                            
                            print("word:")
                            print(word)
                            
                            //赤文字設定
                            let redAttribute:[NSAttributedString.Key:Any]=[
                                .foregroundColor: UIColor.red
                            ]
                            
                            //赤文字変更後の文字列
                            let coloredString = NSMutableAttributedString()
                            
                            for change in diff{
                                switch change{
                                case .remove(let offset, let element, _):
                                    print("remove index:" + String(offset) + "word:" + element)
                                case .insert(let offset, let element, _):
                                    //余計な単語を赤文字にする
                                    word[offset] = NSAttributedString(string:element, attributes: redAttribute)
                                    print("offset: " + String(offset) + " string:" + element)
                                }
                                
                            }
                            
                            var result = PFObject(className:"Results")
                            result["uuid"] = uuid
                            result["answer"] = "incorrect"
                            result["spokenPhrase"] = bestString
                            result.saveInBackground {
                              (success: Bool, error: Error?) in
                              if (success) {
                                // The object has been saved.
                              } else {
                                // There was a problem, check error.description
                              }
                            }
                            
                            
                            
                            let space = " "
                            for i in 0...voicearrlength{
                            coloredString.append(word[i])
                            coloredString.append(NSAttributedString(string:space))
                            }
                            //赤文字変更後をラベルに表示
                            detectedTextLabel.attributedText = coloredString
                        }

                }
    }
    
    @IBAction func startButton(_ sender: UIButton){
            
        configureUI(question: gameModels[currentQ])
        checkRight(question: gameModels[currentQ])
        

    }


}

