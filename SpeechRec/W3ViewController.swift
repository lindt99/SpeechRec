//
//  W3ViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2021/05/13.
//  Copyright © 2021 本田彩. All rights reserved.
//

import UIKit
import Speech
import Diff
import Parse

class W3ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet var detectedTextLabel: UILabel!
    @IBOutlet var StartButton: UIButton!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var startHat: UIImageView!
    @IBOutlet var buttonBG: UIView!
    @IBOutlet var playBtn: UIButton!
    
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
    
    var player: AVAudioPlayer?
    var audioUrlString: String!
    
    var correctCount = 0
    var attemptCount = 0
    
    var totalAudioCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonBG.layer.cornerRadius = 35
        setupQuestionsW1()
        configureUI(question: gameModels.first!)
        configureAudio(question: gameModels.first!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultViewController
        resultVC.correct = correctCount
        resultVC.attempt = attemptCount
    }
    
    private func setupQuestionsW1(){
        gameModels.append(Question(modelPhrase: "I love the bread from Greece", qNum: 1, audioName: "1"))
        gameModels.append(Question(modelPhrase: "I'll take the lobster", qNum: 2, audioName: "2"))
        gameModels.append(Question(modelPhrase: "I'd like to be a millionaire", qNum: 3, audioName: "3"))
        gameModels.append(Question(modelPhrase: "He worked as a volunteer", qNum: 4, audioName: "4"))
        gameModels.append(Question(modelPhrase: "I love going to the bookstore", qNum: 5, audioName: "5"))
        gameModels.append(Question(modelPhrase: "I read the brochure", qNum: 6, audioName: "6"))
        gameModels.append(Question(modelPhrase: "I'm scared to fly in an airplane", qNum: 7, audioName: "7"))
        gameModels.append(Question(modelPhrase: "Hurry up or we will miss the bus", qNum: 8, audioName: "8"))
        gameModels.append(Question(modelPhrase: "I hate horror movies", qNum: 9, audioName: "9"))
        gameModels.append(Question(modelPhrase: "Please take care of my cat", qNum: 10, audioName: "10"))
        gameModels.append(Question(modelPhrase: "Shall we drive or go by train", qNum:11, audioName: "11"))
        gameModels.append(Question(modelPhrase: "She plays the viola really well", qNum: 12, audioName: "12"))
        gameModels.append(Question(modelPhrase: "Can you wrap that bracelet around my wrist", qNum: 13, audioName: "13"))
        gameModels.append(Question(modelPhrase: "Rob reads reports before running", qNum: 14, audioName: "14"))
        gameModels.append(Question(modelPhrase: "I drew a picture of a frog in art class", qNum: 15, audioName: "15"))
        gameModels.append(Question(modelPhrase: "I had a French breakfast in Switzerland", qNum: 16, audioName: "16"))
        gameModels.append(Question(modelPhrase: "That crazy dragonfly took my pretzel", qNum: 17, audioName: "17"))
        gameModels.append(Question(modelPhrase: "I went to visit the aquarium in January", qNum: 18, audioName: "18"))
        gameModels.append(Question(modelPhrase: "The air feels really hot upstairs", qNum: 19, audioName: "19"))
        gameModels.append(Question(modelPhrase: "I unluckily had a flat tire on the way here", qNum: 20, audioName: "20"))
        gameModels.append(Question(modelPhrase: "There was a terrible traffic on the freeway", qNum: 21, audioName: "21"))
        gameModels.append(Question(modelPhrase: "After a hurricane comes a rainbow", qNum: 22, audioName: "22"))
        gameModels.append(Question(modelPhrase: "There's an error in your calculation", qNum: 23, audioName: "23"))
        gameModels.append(Question(modelPhrase: "The stairs were very narrow", qNum: 24, audioName: "24"))
        gameModels.append(Question(modelPhrase: "Do you still live at the same address", qNum: 25, audioName: "25"))
        gameModels.append(Question(modelPhrase: "She reached for an apple from the fruit bowl", qNum: 26, audioName: "26"))
        gameModels.append(Question(modelPhrase: "The cheese ravioli is my favorite", qNum: 27, audioName: "27"))
        gameModels.append(Question(modelPhrase: "I would really like a little red umbrella like Laura's", qNum: 28, audioName: "28"))
        gameModels.append(Question(modelPhrase: "I saw a rainbow while I was listening to the radio in my rowboat", qNum: 29, audioName: "29"))
        gameModels.append(Question(modelPhrase: "You should recycle that tennis racket or give it to a runner", qNum: 30, audioName: "30"))
        gameModels.append(Question(modelPhrase: "11 benevolent elephants", qNum: 31, audioName: "31"))
        gameModels.append(Question(modelPhrase: "Divers dive deep", qNum: 32, audioName: "32"))
        gameModels.append(Question(modelPhrase: "He threw three balls", qNum: 33, audioName: "33"))
        gameModels.append(Question(modelPhrase: "Red Lorry yellow Lorry", qNum: 34, audioName: "34"))
        gameModels.append(Question(modelPhrase: "We surely shall see the sunshine soon", qNum: 35, audioName: "35"))
        gameModels.append(Question(modelPhrase: "A big black bear sat on a big black rug", qNum: 36, audioName: "36"))
        gameModels.append(Question(modelPhrase: "Reading alone allows you to really relax", qNum: 37, audioName: "37"))
        gameModels.append(Question(modelPhrase: "Low rent allows regular lending", qNum: 38, audioName: "38"))
        gameModels.append(Question(modelPhrase: "The bluebird blinks", qNum: 39, audioName: "39"))
        gameModels.append(Question(modelPhrase: "Sally sells seashells by the seashore", qNum: 40, audioName: "40"))
        gameModels.shuffle()
    }
    
    
    
    
    private func configureUI(question: Question){
        questionLabel.text = question.modelPhrase
        
    }
    
    
    private func configureAudio(question: Question){
        audioUrlString = Bundle.main.path(forResource: question.audioName, ofType: "mp3")
    }
    
    
    
    struct Question{
        let modelPhrase: String
        let qNum: Int
        let audioName: String
    }
    
    
    
    
    private func playAudio(question: Question){
        
        print("audioname:\(audioUrlString)")
//        soundLabel.text = "sound playing"
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
                
                var singleAudioCount = PFObject(className:"audioPlay")
                singleAudioCount["uuid"] = uuid
                singleAudioCount["weekNo"] = "W3"
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
                            

                            
                        var result = PFObject(className:"questionW3")
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
                            
                            var result = PFObject(className:"questionW3")
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
        
        configureAudio(question: gameModels[currentQ])
    }


    @IBAction func playAudioButton(){
        playAudio(question: gameModels[currentQ])
        
        
    }
    
    @IBAction func nextQuestion(){
        
        currentQ += 1
//        if currentQ < gameModels.count{
        if currentQ < 20{
            //when there are more questions show the next question and set audio
            configureUI(question: gameModels[currentQ])
            configureAudio(question: gameModels[currentQ])
        } else {
            //when there are no more questions left move to result screen
            performSegue(withIdentifier: "toResultW3", sender: nil)
            
            //send result data to back4app
            var finalResult = PFObject(className:"finalResultW3")
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
            completeCount["weekNo"] = "W3"
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
