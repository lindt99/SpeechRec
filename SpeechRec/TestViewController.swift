//
//  TestViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2021/05/13.
//  Copyright © 2021 本田彩. All rights reserved.
//

import UIKit
import Speech
import Diff
import Parse

class TestViewController: UIViewController, SFSpeechRecognizerDelegate {
        
        @IBOutlet var detectedTextLabel: UILabel!
        @IBOutlet var StartButton: UIButton!
        @IBOutlet weak var resultImage: UIImageView!
        @IBOutlet weak var startHat: UIImageView!
        @IBOutlet var buttonBG: UIView!
        
        @IBOutlet var testLabel: UILabel!
        
        @IBOutlet var questionLabel: UILabel!
        
        @IBOutlet var resultLabel: UILabel!
        
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
        
//        var player: AVAudioPlayer?
//        var audioUrlString: String!
        
        var correctCount = 0
        var attemptCount = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            buttonBG.layer.cornerRadius = 35
            setupQuestionsW1()
            configureUI(question: gameModels.first!)
//            configureAudio(question: gameModels.first!)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let resultVC = segue.destination as! ResultViewController
            resultVC.correct = correctCount
            resultVC.attempt = attemptCount
        }
        
        private func setupQuestionsW1(){
            gameModels.append(Question(modelPhrase: "I love the bread from Greece", qNum: 1, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I'll take the lobster", qNum: 2, audioName: "lobster"))
            gameModels.append(Question(modelPhrase: "I'd like to be a millionaire", qNum: 3, audioName: "millionaire"))
            gameModels.append(Question(modelPhrase: "He worked as a volunteer", qNum: 4, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I love going to the bookstore", qNum: 5, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I read the brochure", qNum: 6, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I'm scared to fly in an airplane", qNum: 7, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Hurry up or we'll miss the bus", qNum: 8, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I hate horror movies", qNum: 9, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Please take care of my cat", qNum: 10, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Shall we drive or go by train?", qNum:11, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "She plays the viola really well", qNum: 12, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Can you wrap that bracelet around my wrist", qNum: 13, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Rob reads reports before running", qNum: 14, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I drew a picture of a frog in art class", qNum: 15, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I had a French breakfast in Switzerland", qNum: 16, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "That crazy dragonfly took my pretzel", qNum: 17, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I went to visit the aquarium in January", qNum: 18, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "The air feels really hot upstairs", qNum: 19, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I unluckily had a flat tire on the way here", qNum: 20, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "There was a terrible traffic on the freeway", qNum: 21, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "After a hurricane comes a rainbow", qNum: 22, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "There's an error in your calculation", qNum: 23, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "The stairs were very narrow", qNum: 24, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Do you still live at the same address", qNum: 25, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "She reached for an apple from the fruit bowl", qNum: 26, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "The cheese ravioli is my favorite", qNum: 27, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I would really like a little red umbrella like Laura's", qNum: 28, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "I saw a rainbow while I was listening to the radio in my rowboat", qNum: 29, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "You should recycle that tennis racket or give it to a runner", qNum: 30, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "11 benevolent elephants", qNum: 31, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Divers dive deep", qNum: 32, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "He threw three balls", qNum: 33, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Red Lorry yellow Lorry", qNum: 34, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "We surely shall see the sunshine soon", qNum: 35, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "A big black bear sat on a big black rug", qNum: 36, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Reading alone allows you to really relax", qNum: 37, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Low rent allows regular lending", qNum: 38, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "The bluebird blinks", qNum: 39, audioName: "bread"))
            gameModels.append(Question(modelPhrase: "Sally sells seashells by the seashore", qNum: 40, audioName: "bread"))
        }
        
        
        
        
        private func configureUI(question: Question){
            questionLabel.text = question.modelPhrase
            
        }
        
        
//        private func configureAudio(question: Question){
//            audioUrlString = Bundle.main.path(forResource: question.audioName, ofType: "mp3")
//        }
        
        
        
        struct Question{
            let modelPhrase: String
            let qNum: Int
            let audioName: String
        }
        
        
        
        
//        private func playAudio(question: Question){
//
//            print("audioname:\(audioUrlString)")
//
//            do {
//                try AVAudioSession.sharedInstance().setMode(.default)
//                try AVAudioSession.sharedInstance().setCategory(
//                    AVAudioSession.Category.playback
//                )
//                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//
//                guard let audioUrlString = audioUrlString else{
//                    return
//                }
//
//                player = try AVAudioPlayer(contentsOf: URL(string: audioUrlString)!)
//
//                guard player == player else{
//                    return
//                }
//                if player!.isPlaying == true{
//                    player?.pause()
//                } else {
//                    player?.prepareToPlay()
//                    player?.play()
//                }
//            } catch  {
//                print("error occurred")
//            }
//        }
        
        
        
        
        
        
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
                if result != nil{
                    if let result = result {
                        self.bestString = result.bestTranscription.formattedString
                        self.detectedTextLabel.text = self.bestString
                    
                    } else if let error = error {
                        print(error)
                    }
                }
            })
        }
        
        func checkRight(question:Question){

            
                    
                    isRecording.toggle()
                            
                    if isRecording == true {
                        
                        let audioSession = AVAudioSession.sharedInstance()
                        do {
                          try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
                            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)}
                        catch let error as NSError {
                          print("ERROR:", error)
                        }
                        
                            self.recordAndRecognizeSpeech()
                            StartButton.setTitle("Stop", for: .normal)
                        
                    } else if isRecording == false {
                            recognitionTask?.cancel()
                            StartButton.setTitle("Start", for: .normal)
                        attemptCount += 1
                        
                        //stop processing audio
                        let audioSession = AVAudioSession.sharedInstance()
                        
                        do {
                            try audioSession.setActive(false, options:.notifyOthersOnDeactivation)}
                        catch let error as NSError {
                          print("ERROR:", error)
                        }
                        
                        audioEngine.inputNode.removeTap(onBus: 0)
                        audioEngine.stop()
                        request.endAudio()
                        
                        
                        if question.modelPhrase == bestString{
                                
                                print("correct pronunciation")
                            correctCount += 1
                            resultLabel.text = "Result: Correct!"
                            
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
                                result["modelPhrase"] = question.modelPhrase
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
                            
                                
                            resultLabel.text = "Result: Incorrect"
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
                                result["modelPhrase"] = question.modelPhrase
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

                        print("correct:\(correctCount),no. attempt:\(attemptCount)")
                    }
        }
        
        @IBAction func startButton(_ sender: UIButton){
            checkRight(question: gameModels[currentQ])
            
//            configureAudio(question: gameModels[currentQ])
        }


//        @IBAction func playAudioButton(){
//            playAudio(question: gameModels[currentQ])
//
//
//        }
        
        @IBAction func nextQuestion(){
            
            currentQ += 1
            if currentQ < gameModels.count{
                //when there are more questions show the next question and set audio
                configureUI(question: gameModels[currentQ])
//                configureAudio(question: gameModels[currentQ])
            } else {
                //when there are no more questions left move to result screen
                performSegue(withIdentifier: "toResultTest", sender: nil)
                
                //send result data to back4app
                var finalResult = PFObject(className:"finalResultTest1")
                finalResult["uuid"] = uuid
                finalResult["totalCorrect"] = correctCount
                finalResult["totalAttempt"] = attemptCount
                finalResult.saveInBackground {
                  (success: Bool, error: Error?) in
                  if (success) {
                    // The object has been saved.
                  } else {
                    // There was a problem, check error.description
                  }
                }
            }
        }
    }
