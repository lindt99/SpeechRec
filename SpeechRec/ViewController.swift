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
                            
                        //uuid,answer,spokenPhraseをMySQLに保存
        //                    //POSTリクエスト用の変数定義
        //                    var postString: String? = nil
        //                    let urlpost = URL(string: "http://martini.ht.sfc.keio.ac.jp/~lindt/demo.js")!
        //                    var requestpost = URLRequest(url: urlpost)
        //                    requestpost.httpMethod = "POST"
        //
        //                    //uuid取得
        //                    let uuid = UIDevice.current.identifierForVendor?.uuidString
        //                    var answer = "correct"
        //
        //                    postString = "uuid=12345"
        //                    ////      POSTリクエストPHPに送信
        //
        //                    requestpost.httpBody = postString?.data(using: .utf8)
        //                    let taskpost = URLSession.shared.dataTask(with: requestpost, completionHandler: {
        //                        (data, response, error) in
        //
        //                        if error != nil {
        //                            print(error)
        //                            return
        //                        }
        //
        //                        print("response: \(response!)")
        //
        //                        let phpOutput = String(data: data!, encoding: .utf8)!
        //                        print("php output: \(phpOutput)")
        //
        //
        //                    })
        //                    taskpost.resume()
                        //MySQL終わり
                            
                            
                            

                                       

                            
                            
                        } else{
                            
        //                    let (diffRange, diffString) = diff(modelPhrase, bestString)!
                            
                            //change hat image
                            if (startHat.alpha > 0){
                                //delete orange hat if still visible
                                startHat.alpha = 0
                            } else {
                                
                            }
                            resultImage.image = UIImage(named: "hatredr")
                            
                            let modelarr:[String] = modelPhrase.components(separatedBy: " ")
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
            
        checkRight(question: gameModels.qNum)
        

    }


}

