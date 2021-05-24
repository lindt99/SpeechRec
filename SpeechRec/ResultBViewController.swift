//
//  ResultBViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2021/05/25.
//  Copyright © 2021 本田彩. All rights reserved.
//

import UIKit

class ResultBViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    
    
    var correct = 0
    
    var attempt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "\(attempt)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToTitle(_ sender: Any){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
