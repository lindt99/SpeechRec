//
//  W2RViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2021/05/25.
//  Copyright © 2021 本田彩. All rights reserved.
//

import UIKit
import Speech
import Diff
import Parse
import AVFoundation

class W2RViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet var detectedTextLabel: UILabel!
    @IBOutlet var StartButton: UIButton!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var startHat: UIImageView!
    @IBOutlet var buttonBG: UIView!
//    @IBOutlet var playBtn: UIButton!
    
//    @IBOutlet var testLabel: UILabel!
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var UUIDLabel: UILabel!
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording: Bool = false
    var modelPhrase = String("Hello world is the first step to coding")
    var bestString: String = ""
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    var gameModels = [QuestionWord]()
    var currentQ: Int = 0
    
    var player: AVAudioPlayer?
    var audioUrlString: String!
    
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
        UUIDLabel.text = uuid
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultViewController
        resultVC.correct = correctCount
        resultVC.attempt = attemptCount
    }
    
    private func setupQuestionsW1(){
        gameModels.append(QuestionWord(modelPhrase: "Love", qNum: 1, audioName: "love"))
        gameModels.append(QuestionWord(modelPhrase: "Bread", qNum: 2, audioName: "bread"))
        gameModels.append(QuestionWord(modelPhrase: "France", qNum: 3, audioName: "France"))
        gameModels.append(QuestionWord(modelPhrase: "Take", qNum: 4, audioName: "take"))
        gameModels.append(QuestionWord(modelPhrase: "Lobster", qNum: 5, audioName: "lobster"))
        gameModels.append(QuestionWord(modelPhrase: "Like", qNum: 6, audioName: "like"))
        gameModels.append(QuestionWord(modelPhrase: "Millionaire", qNum: 7, audioName: "millionaire"))
        gameModels.append(QuestionWord(modelPhrase: "Worked", qNum: 8, audioName: "worked"))
        gameModels.append(QuestionWord(modelPhrase: "Volunteer", qNum: 9, audioName: "volunteer"))
        gameModels.append(QuestionWord(modelPhrase: "Going", qNum: 10, audioName: "going"))
        gameModels.append(QuestionWord(modelPhrase: "Bookstore", qNum: 11, audioName: "bookstore"))
        gameModels.append(QuestionWord(modelPhrase: "Read", qNum: 12, audioName: "read"))
        gameModels.append(QuestionWord(modelPhrase: "Brochure", qNum: 13, audioName: "brochure"))
        gameModels.append(QuestionWord(modelPhrase: "Scared", qNum: 14, audioName: "scared"))
        gameModels.append(QuestionWord(modelPhrase: "Fly", qNum: 15, audioName: "fly"))
        gameModels.append(QuestionWord(modelPhrase: "Airplane", qNum: 16, audioName: "airplane"))
        gameModels.append(QuestionWord(modelPhrase: "Hurry", qNum: 17, audioName: "hurry"))
        gameModels.append(QuestionWord(modelPhrase: "Hate", qNum: 18, audioName: "hate"))
        gameModels.append(QuestionWord(modelPhrase: "Horror", qNum: 19, audioName: "horror"))
        gameModels.append(QuestionWord(modelPhrase: "Movies", qNum: 20, audioName: "movies"))
        gameModels.append(QuestionWord(modelPhrase: "Please", qNum: 21, audioName: "please"))
        gameModels.append(QuestionWord(modelPhrase: "Care", qNum: 22, audioName: "care"))
        gameModels.append(QuestionWord(modelPhrase: "Drive", qNum: 23, audioName: "drive"))
        gameModels.append(QuestionWord(modelPhrase: "Train", qNum: 24, audioName: "train"))
        gameModels.append(QuestionWord(modelPhrase: "Viola", qNum: 25, audioName: "viola"))
        gameModels.append(QuestionWord(modelPhrase: "Really", qNum: 26, audioName: "really"))
        gameModels.append(QuestionWord(modelPhrase: "Well", qNum: 27, audioName: "well"))
        gameModels.append(QuestionWord(modelPhrase: "Rap", qNum: 28, audioName: "rap"))
        gameModels.append(QuestionWord(modelPhrase: "Bracelet", qNum: 29, audioName: "bracelet"))
        gameModels.append(QuestionWord(modelPhrase: "Around", qNum: 30, audioName: "around"))
        gameModels.append(QuestionWord(modelPhrase: "Wrist", qNum: 31, audioName: "wrist"))
        gameModels.append(QuestionWord(modelPhrase: "Reports", qNum: 32, audioName: "reports"))
        gameModels.append(QuestionWord(modelPhrase: "Before", qNum: 33, audioName: "before"))
        gameModels.append(QuestionWord(modelPhrase: "Running", qNum: 34, audioName: "running"))
        gameModels.append(QuestionWord(modelPhrase: "Picture", qNum: 35, audioName: "picture"))
        gameModels.append(QuestionWord(modelPhrase: "Frog", qNum: 36, audioName: "frog"))
        gameModels.append(QuestionWord(modelPhrase: "Art", qNum: 37, audioName: "art"))
        gameModels.append(QuestionWord(modelPhrase: "Class", qNum: 38, audioName: "class"))
        gameModels.append(QuestionWord(modelPhrase: "French", qNum: 39, audioName: "french"))
        gameModels.append(QuestionWord(modelPhrase: "Breakfast", qNum: 40, audioName: "breakfast"))
        gameModels.append(QuestionWord(modelPhrase: "Switzerland", qNum: 41, audioName: "switzerland"))
        gameModels.append(QuestionWord(modelPhrase: "Crazy", qNum: 42, audioName: "crazy"))
        gameModels.append(QuestionWord(modelPhrase: "Dragonfly", qNum: 43, audioName: "dragonfly"))
        gameModels.append(QuestionWord(modelPhrase: "Pretzel", qNum: 44, audioName: "pretzel"))
        gameModels.append(QuestionWord(modelPhrase: "Visit", qNum: 45, audioName: "visit"))
        gameModels.append(QuestionWord(modelPhrase: "Aquarium", qNum: 46, audioName: "aquarium"))
        gameModels.append(QuestionWord(modelPhrase: "January", qNum: 47, audioName: "january"))
        gameModels.append(QuestionWord(modelPhrase: "Air", qNum: 48, audioName: "air"))
        gameModels.append(QuestionWord(modelPhrase: "Feel", qNum: 49, audioName: "feel"))
        gameModels.append(QuestionWord(modelPhrase: "Hot", qNum: 50, audioName: "hot"))
        gameModels.append(QuestionWord(modelPhrase: "Upstairs", qNum: 51, audioName: "upstairs"))
        gameModels.append(QuestionWord(modelPhrase: "Unfortunately", qNum: 52, audioName: "unfortunately"))
        gameModels.append(QuestionWord(modelPhrase: "Flat", qNum: 53, audioName: "flat"))
        gameModels.append(QuestionWord(modelPhrase: "Tire", qNum: 54, audioName: "tire"))
        gameModels.append(QuestionWord(modelPhrase: "Here", qNum: 55, audioName: "here"))
        gameModels.append(QuestionWord(modelPhrase: "Terrible", qNum: 56, audioName: "terrible"))
        gameModels.append(QuestionWord(modelPhrase: "Traffic", qNum: 57, audioName: "traffic"))
        gameModels.append(QuestionWord(modelPhrase: "Freeway", qNum: 58, audioName: "freeway"))
        gameModels.append(QuestionWord(modelPhrase: "After", qNum: 59, audioName: "after"))
        gameModels.append(QuestionWord(modelPhrase: "Hurricane", qNum: 60, audioName: "hurricane"))
        gameModels.append(QuestionWord(modelPhrase: "Rainbow", qNum: 61, audioName: "rainbow"))
        gameModels.append(QuestionWord(modelPhrase: "Error", qNum: 62, audioName: "error"))
        gameModels.append(QuestionWord(modelPhrase: "Calculation", qNum: 63, audioName: "calculation"))
        gameModels.append(QuestionWord(modelPhrase: "Stairs", qNum: 64, audioName: "stairs"))
        gameModels.append(QuestionWord(modelPhrase: "Very", qNum: 65, audioName: "very"))
        gameModels.append(QuestionWord(modelPhrase: "Narrow", qNum: 66, audioName: "narrow"))
        gameModels.append(QuestionWord(modelPhrase: "Still", qNum: 67, audioName: "still"))
        gameModels.append(QuestionWord(modelPhrase: "Live", qNum: 68, audioName: "live"))
        gameModels.append(QuestionWord(modelPhrase: "Same", qNum: 69, audioName: "same"))
        gameModels.append(QuestionWord(modelPhrase: "Address", qNum: 70, audioName: "address"))
        gameModels.append(QuestionWord(modelPhrase: "Reached", qNum: 71, audioName: "reached"))
        gameModels.append(QuestionWord(modelPhrase: "Apple", qNum: 72, audioName: "apple"))
        gameModels.append(QuestionWord(modelPhrase: "Fruit", qNum: 73, audioName: "fruit"))
        gameModels.append(QuestionWord(modelPhrase: "Bowl", qNum: 74, audioName: "bowl"))
        gameModels.append(QuestionWord(modelPhrase: "Ravioli", qNum: 75, audioName: "ravioli"))
        gameModels.append(QuestionWord(modelPhrase: "Favorite", qNum: 76, audioName: "favorite"))
        gameModels.append(QuestionWord(modelPhrase: "Little", qNum: 77, audioName: "little"))
        gameModels.append(QuestionWord(modelPhrase: "Umbrella", qNum: 78, audioName: "umbrella"))
        gameModels.append(QuestionWord(modelPhrase: "While", qNum: 79, audioName: "while"))
        gameModels.append(QuestionWord(modelPhrase: "Listening", qNum: 80, audioName: "listening"))
        gameModels.append(QuestionWord(modelPhrase: "Radio", qNum: 81, audioName: "radio"))
        gameModels.append(QuestionWord(modelPhrase: "Row boat", qNum: 82, audioName: "rowboat"))
        gameModels.append(QuestionWord(modelPhrase: "Recycle", qNum: 83, audioName: "recycle"))
        gameModels.append(QuestionWord(modelPhrase: "Tennis", qNum: 84, audioName: "tennis"))
        gameModels.append(QuestionWord(modelPhrase: "Racket", qNum: 85, audioName: "racket"))
        gameModels.append(QuestionWord(modelPhrase: "Give", qNum: 86, audioName: "give"))
        gameModels.append(QuestionWord(modelPhrase: "Runner", qNum: 87, audioName: "runner"))
        
        gameModels.shuffle()
    }
    
    
    
    
    private func configureUI(question: QuestionWord){
        questionLabel.text = question.modelPhrase
        
    }
    
    
    private func configureAudio(question: QuestionWord){
        audioUrlString = Bundle.main.path(forResource: question.audioName, ofType: "mp3")
    }
    
    
    
    struct QuestionWord{
        let modelPhrase: String
        let qNum: Int
        let audioName: String
    }
    
    
    
    
    private func playAudio(question: QuestionWord){
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback
            )
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let audioUrlString = audioUrlString else{
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: audioUrlString)!)
            
            guard player == player else{
                return
            }
            if player!.isPlaying == true{
                player?.pause()
            } else {
                player?.prepareToPlay()
                player?.play()
                totalAudioCount += 1
                
                var singleAudioCount = PFObject(className:"audioPlayV")
                singleAudioCount["uuid"] = uuid
                singleAudioCount["weekNo"] = "W2R"
                singleAudioCount["modelPhrase"] = question.modelPhrase
                singleAudioCount["qNo"] = question.qNum
                singleAudioCount.saveInBackground {
                  (success: Bool, error: Error?) in
                  if (success) {
                    // The object has been saved.
                  } else {
                    // There was a problem, check error.description
                  }
                }
                
            }
        } catch  {
            print("error occurred")
        }
        
        
//        AVSpeechUtterance(string: question.modelPhrase).voice = AVSpeechSynthesisVoice(language: "en-US")
//        AVSpeechUtterance(string: question.modelPhrase).rate = 0.45
//
//        synthesizer.speak(AVSpeechUtterance(string: question.modelPhrase))
        
        
        
//        totalAudioCount += 1
        
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
    
    func checkRight(question:QuestionWord){

        
                
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
                            

                            
                            var result = PFObject(className:"questionW2R")
                            result["uuid"] = uuid
                            result["answer"] = "correct"
                            result["spokenPhrase"] = bestString
                            result["qNo"] = question.qNum
                            result["modelPhrase"] = question.modelPhrase
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
                            
                            var result = PFObject(className:"questionW2R")
                            result["uuid"] = uuid
                            result["answer"] = "incorrect"
                            result["spokenPhrase"] = bestString
                            result["qNo"] = question.qNum
                            result["modelPhrase"] = question.modelPhrase
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
        
//        configureAudio(question: gameModels[currentQ])
    }


    @IBAction func playAudioButton(){
        configureAudio(question: gameModels[currentQ])
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
            performSegue(withIdentifier: "toResultW2R", sender: nil)
            
            //send result data to back4app
            var finalResult = PFObject(className:"finalResultW2R")
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
            
            var completeCount = PFObject(className:"completeRed")
            completeCount["uuid"] = uuid
            completeCount["weekNo"] = "W2R"
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
