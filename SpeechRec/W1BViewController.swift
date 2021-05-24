//
//  W1BViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2021/05/25.
//  Copyright © 2021 本田彩. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class W1BViewController: UIViewController {
    
    //    @IBOutlet var detectedTextLabel: UILabel!
    //    @IBOutlet var StartButton: UIButton!
    //    @IBOutlet weak var resultImage: UIImageView!
    //    @IBOutlet weak var startHat: UIImageView!
        @IBOutlet var buttonBG: UIView!
    //    @IBOutlet var playBtn: UIButton!
        
    //    @IBOutlet var testLabel: UILabel!
        
        @IBOutlet var questionLabel: UILabel!
        
    //    @IBOutlet var resultLabel: UILabel!
        
        
    //    let audioEngine = AVAudioEngine()
    //    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    //    let request = SFSpeechAudioBufferRecognitionRequest()
    //    var recognitionTask: SFSpeechRecognitionTask?
    //    var isRecording: Bool = false
        var modelPhrase = String("Hello world is the first step to coding")
        var bestString: String = ""
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        
        var gameModels = [QuestionWord]()
        var currentQ: Int = 0
        
        var player: AVAudioPlayer?
    //    var audioUrlString: String!
        
        var correctCount = 0
        var attemptCount = 0
        var singleAudioCount = 0
        var totalAudioCount = 0
    
    let synthesizer = AVSpeechSynthesizer()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            buttonBG.layer.cornerRadius = 35
            setupQuestionsW1()
            configureUI(question: gameModels.first!)
    //        configureAudio(question: gameModels.first!)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let resultVC = segue.destination as! ResultBViewController
            resultVC.attempt = totalAudioCount
        }
        
        private func setupQuestionsW1(){
            gameModels.append(QuestionWord(modelPhrase: "Love", qNum: 1))
            gameModels.append(QuestionWord(modelPhrase: "Bread", qNum: 2))
            gameModels.append(QuestionWord(modelPhrase: "France", qNum: 3))
            gameModels.append(QuestionWord(modelPhrase: "Take", qNum: 4))
            gameModels.append(QuestionWord(modelPhrase: "Lobster", qNum: 5))
            gameModels.append(QuestionWord(modelPhrase: "Like", qNum: 6))
            gameModels.append(QuestionWord(modelPhrase: "Millionaire", qNum: 7))
            gameModels.append(QuestionWord(modelPhrase: "Worked", qNum: 8))
            gameModels.append(QuestionWord(modelPhrase: "Volunteer", qNum: 9))
            gameModels.append(QuestionWord(modelPhrase: "Going", qNum: 10))
            gameModels.append(QuestionWord(modelPhrase: "Bookstore", qNum: 11))
            gameModels.append(QuestionWord(modelPhrase: "Read", qNum: 12))
            gameModels.append(QuestionWord(modelPhrase: "Brochure", qNum: 13))
            gameModels.append(QuestionWord(modelPhrase: "Scared", qNum: 14))
            gameModels.append(QuestionWord(modelPhrase: "Fly", qNum: 15))
            gameModels.append(QuestionWord(modelPhrase: "Airplane", qNum: 16))
            gameModels.append(QuestionWord(modelPhrase: "Hurry", qNum: 17))
            gameModels.append(QuestionWord(modelPhrase: "Hate", qNum: 18))
            gameModels.append(QuestionWord(modelPhrase: "Horror", qNum: 19))
            gameModels.append(QuestionWord(modelPhrase: "Movies", qNum: 20))
            gameModels.append(QuestionWord(modelPhrase: "Please", qNum: 21))
            gameModels.append(QuestionWord(modelPhrase: "Care", qNum: 22))
            gameModels.append(QuestionWord(modelPhrase: "Drive", qNum: 23))
            gameModels.append(QuestionWord(modelPhrase: "Train", qNum: 24))
            gameModels.append(QuestionWord(modelPhrase: "Viola", qNum: 25))
            gameModels.append(QuestionWord(modelPhrase: "Really", qNum: 26))
            gameModels.append(QuestionWord(modelPhrase: "Well", qNum: 27))
            gameModels.append(QuestionWord(modelPhrase: "Rap", qNum: 28))
            gameModels.append(QuestionWord(modelPhrase: "Bracelet", qNum: 29))
            gameModels.append(QuestionWord(modelPhrase: "Around", qNum: 30))
            gameModels.append(QuestionWord(modelPhrase: "Wrist", qNum: 31))
            gameModels.append(QuestionWord(modelPhrase: "Reports", qNum: 32))
            gameModels.append(QuestionWord(modelPhrase: "Before", qNum: 33))
            gameModels.append(QuestionWord(modelPhrase: "Running", qNum: 34))
            gameModels.append(QuestionWord(modelPhrase: "Picture", qNum: 35))
            gameModels.append(QuestionWord(modelPhrase: "Frog", qNum: 36))
            gameModels.append(QuestionWord(modelPhrase: "Art", qNum: 37))
            gameModels.append(QuestionWord(modelPhrase: "Class", qNum: 38))
            gameModels.append(QuestionWord(modelPhrase: "French", qNum: 39))
            gameModels.append(QuestionWord(modelPhrase: "Breakfast", qNum: 40))
            gameModels.append(QuestionWord(modelPhrase: "Switzerland", qNum: 41))
            gameModels.append(QuestionWord(modelPhrase: "Crazy", qNum: 42))
            gameModels.append(QuestionWord(modelPhrase: "Dragonfly", qNum: 43))
            gameModels.append(QuestionWord(modelPhrase: "Pretzel", qNum: 44))
            gameModels.append(QuestionWord(modelPhrase: "Visit", qNum: 45))
            gameModels.append(QuestionWord(modelPhrase: "Aquarium", qNum: 46))
            gameModels.append(QuestionWord(modelPhrase: "January", qNum: 47))
            gameModels.append(QuestionWord(modelPhrase: "Air", qNum: 48))
            gameModels.append(QuestionWord(modelPhrase: "Feel", qNum: 49))
            gameModels.append(QuestionWord(modelPhrase: "Hot", qNum: 50))
            gameModels.append(QuestionWord(modelPhrase: "Upstairs", qNum: 51))
            gameModels.append(QuestionWord(modelPhrase: "Unfortunately", qNum: 52))
            gameModels.append(QuestionWord(modelPhrase: "Flat", qNum: 53))
            gameModels.append(QuestionWord(modelPhrase: "Tire", qNum: 54))
            gameModels.append(QuestionWord(modelPhrase: "Here", qNum: 55))
            
            
            gameModels.shuffle()
        }
        
        
        
        
        private func configureUI(question: QuestionWord){
            questionLabel.text = question.modelPhrase
            questionLabel.layer.borderWidth = 5
            questionLabel.layer.borderColor = UIColor.orange.cgColor
        }
        
        
    //    private func configureAudio(question: Question){
    //        audioUrlString = Bundle.main.path(forResource: question.audioName, ofType: "mp3")
    //    }
        
        
        
        struct QuestionWord{
            let modelPhrase: String
            let qNum: Int
        }
        
        
        
        
        private func playAudio(question: QuestionWord){
            
           
            AVSpeechUtterance(string: question.modelPhrase).voice = AVSpeechSynthesisVoice(language: "en-US")
            AVSpeechUtterance(string: question.modelPhrase).rate = 0.45
            
            synthesizer.speak(AVSpeechUtterance(string: question.modelPhrase))
            
            
            totalAudioCount += 1
        }
        
        
        
        
        
        
    //    func recordAndRecognizeSpeech(){
    //
    //
    //        let node = audioEngine.inputNode
    //        let recordingFormat = node.outputFormat(forBus: 0)
    //        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
    //            buffer, _ in self.request.append(buffer)
    //        }
    //
    //
    //        audioEngine.prepare()
    //        do{
    //            try audioEngine.start()
    //        } catch {
    //            return print(error)
    //        }
    //
    //
    //        guard let myRecognizer = SFSpeechRecognizer() else{
    //            return
    //        }
    //        if !myRecognizer.isAvailable{
    //            return
    //        }
    //
    //
    //        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
    //            if result != nil{
    //                if let result = result {
    //                    self.bestString = result.bestTranscription.formattedString
    //                    self.detectedTextLabel.text = self.bestString
    //
    //                } else if let error = error {
    //                    print(error)
    //                }
    //            }
    //        })
    //    }
        
    //    func checkRight(question:QuestionWord){
    //
    //
    //
    //                isRecording.toggle()
    //
    //                if isRecording == true {
    //
    //                    let audioSession = AVAudioSession.sharedInstance()
    //                    do {
    //                      try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
    //                        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)}
    //                    catch let error as NSError {
    //                      print("ERROR:", error)
    //                    }
    //
    //                        self.recordAndRecognizeSpeech()
    //                        StartButton.setTitle("Stop", for: .normal)
    //
    //                } else if isRecording == false {
    //                        recognitionTask?.cancel()
    //                        StartButton.setTitle("Start", for: .normal)
    //                    attemptCount += 1
    //
    //                    //stop processing audio
    //                    let audioSession = AVAudioSession.sharedInstance()
    //
    //                    do {
    //                        try audioSession.setActive(false, options:.notifyOthersOnDeactivation)}
    //                    catch let error as NSError {
    //                      print("ERROR:", error)
    //                    }
    //
    //                    audioEngine.inputNode.removeTap(onBus: 0)
    //                    audioEngine.stop()
    //                    request.endAudio()
    //
    //
    //                    if question.modelPhrase == bestString{
    //
    //                            print("correct pronunciation")
    //                        correctCount += 1
    //                        resultLabel.text = "Result: Correct!"
    //
    //                            //change hat image
    //                            if (startHat.alpha > 0){
    //                                //delete orage hat if still visible
    //                                startHat.alpha = 0
    //                            } else {
    //
    //                            }
    //                            resultImage.image = UIImage(named: "hatgreenr")
    //
    //
    //
    //                            var result = PFObject(className:"questionW1")
    //                            result["uuid"] = uuid
    //                            result["answer"] = "correct"
    //                            result["spokenPhrase"] = bestString
    //                            result["qNo"] = question.qNum
    //                            result["modelPhrase"] = question.modelPhrase
    //                            result.saveInBackground {
    //                              (success: Bool, error: Error?) in
    //                              if (success) {
    //                                // The object has been saved.
    //                              } else {
    //                                // There was a problem, check error.description
    //                              }
    //                            }
    //
    //
    //                        } else{
    //
    //
    //                        resultLabel.text = "Result: Incorrect"
    //                            //change hat image
    //                            if (startHat.alpha > 0){
    //                                //delete orange hat if still visible
    //                                startHat.alpha = 0
    //                            } else {
    //
    //                            }
    //                            resultImage.image = UIImage(named: "hatredr")
    //
    //                        let modelarr:[String] = question.modelPhrase.components(separatedBy: " ")
    //                            let voicearr:[String] = bestString.components(separatedBy: " ")
    //
    //                            let voicearrlength = voicearr.count - 1
    //
    //                            //ordered collection diffing
    //                            let diff = voicearr.difference(from: modelarr)
    //
    //                            var word:[NSAttributedString] = []
    //
    //                            for voicearrword in 0...voicearrlength{
    //                                word.append(NSAttributedString(string: (voicearr[voicearrword])))
    //                            }
    //
    //                            print("word:")
    //                            print(word)
    //
    //                            //赤文字設定
    //                            let redAttribute:[NSAttributedString.Key:Any]=[
    //                                .foregroundColor: UIColor.red
    //                            ]
    //
    //                            //赤文字変更後の文字列
    //                            let coloredString = NSMutableAttributedString()
    //
    //                            for change in diff{
    //                                switch change{
    //                                case .remove(let offset, let element, _):
    //                                    print("remove index:" + String(offset) + "word:" + element)
    //                                case .insert(let offset, let element, _):
    //                                    //余計な単語を赤文字にする
    //                                    word[offset] = NSAttributedString(string:element, attributes: redAttribute)
    //                                    print("offset: " + String(offset) + " string:" + element)
    //                                }
    //
    //                            }
    //
    //                            var result = PFObject(className:"questionW1")
    //                            result["uuid"] = uuid
    //                            result["answer"] = "incorrect"
    //                            result["spokenPhrase"] = bestString
    //                            result["qNo"] = question.qNum
    //                            result["modelPhrase"] = question.modelPhrase
    //                            result.saveInBackground {
    //                              (success: Bool, error: Error?) in
    //                              if (success) {
    //                                // The object has been saved.
    //                              } else {
    //                                // There was a problem, check error.description
    //                              }
    //                            }
    //
    //
    //
    //                            let space = " "
    //                            for i in 0...voicearrlength{
    //                            coloredString.append(word[i])
    //                            coloredString.append(NSAttributedString(string:space))
    //                            }
    //                            //赤文字変更後をラベルに表示
    //                            detectedTextLabel.attributedText = coloredString
    //                        }
    //
    //                    print("correct:\(correctCount),no. attempt:\(attemptCount)")
    //                }
    //    }
        
    //    @IBAction func startButton(_ sender: UIButton){
    //        checkRight(question: gameModels[currentQ])
    //
    ////        configureAudio(question: gameModels[currentQ])
    //    }


        @IBAction func playAudioButton(){
            playAudio(question: gameModels[currentQ])
            
            
        }
        
        @IBAction func nextQuestion(){
            
            currentQ += 1
    //        if currentQ < gameModels.count{
            if currentQ < 40{
                //when there are more questions show the next question and set audio
                configureUI(question: gameModels[currentQ])
    //            configureAudio(question: gameModels[currentQ])
            } else {
                //when there are no more questions left move to result screen
                performSegue(withIdentifier: "toResultW1B", sender: nil)
                
                //send result data to back4app
                var finalResult = PFObject(className:"finalResultW1")
                finalResult["uuid"] = uuid
                finalResult["totalAttempt"] = attemptCount
                finalResult["totalCorrect"] = correctCount
                if attemptCount < 1{
                    finalResult["correctRate"] = 0
                } else if correctCount < 1{
                    finalResult["correctRate"] = 0
                } else{
                    finalResult["correctRate"] = Float(Float(correctCount)/Float(attemptCount))*100
                }
                finalResult["totalAudioCount"] = totalAudioCount
                finalResult.saveInBackground {
                  (success: Bool, error: Error?) in
                  if (success) {
                    // The object has been saved.
                  } else {
                    // There was a problem, check error.description
                  }
                }
                
                var completeCount = PFObject(className:"complete")
                completeCount["uuid"] = uuid
                completeCount["weekNo"] = "W1"
                completeCount["totalAttempt"] = attemptCount
                completeCount["totalCorrect"] = correctCount
                if attemptCount < 1{
                    completeCount["correctRate"] = 0
                } else if correctCount < 1{
                    completeCount["correctRate"] = 0
                } else{
                    completeCount["correctRate"] = Float(Float(correctCount)/Float(attemptCount))*100
                }
                completeCount.saveInBackground {
                  (success: Bool, error: Error?) in
                  if (success) {
                    // The object has been saved.
                  } else {
                    // There was a problem, check error.description
                  }
                }
                
            }
        }
        
        @IBAction func goToTitle(_ sender: Any) {
            self.presentingViewController?.dismiss(animated: true)
        }
        
        
        
    }
