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
        gameModels.append(Question(modelPhrase: "I love the bread from Greece", qNum: 1, audioName: "bread"))
        gameModels.append(Question(modelPhrase: "I'll take the lobster", qNum: 2, audioName: "lobster"))
        gameModels.append(Question(modelPhrase: "I'd like to be a millionaire", qNum: 3, audioName: "millionaire"))
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
                player?.play()
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
                    
                        self.recordAndRecognizeSpeech()
                        StartButton.setTitle("Stop", for: .normal)
                    
                } else if isRecording == false {
                        recognitionTask?.cancel()
                        StartButton.setTitle("Start", for: .normal)
                    attemptCount += 1
                    
                    //stop processing audio
                    audioEngine.inputNode.removeTap(onBus: 0)
                    
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
        
        configureAudio(question: gameModels[currentQ])
    }


    @IBAction func playAudioButton(){
        playAudio(question: gameModels[currentQ])
        
        
    }
    
    @IBAction func nextQuestion(){
        
        currentQ += 1
        if currentQ < gameModels.count{
            //when there are more questions show the next question and set audio
            configureUI(question: gameModels[currentQ])
            configureAudio(question: gameModels[currentQ])
        } else {
            //when there are no more questions left move to result screen
            performSegue(withIdentifier: "toResultW1", sender: nil)
            
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

