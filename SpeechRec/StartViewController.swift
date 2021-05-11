//
//  StartViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2021/05/11.
//  Copyright © 2021 本田彩. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var UUIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UUIDLabel.text = "ID:\(String(describing: UIDevice.current.identifierForVendor!.uuidString))"
    }
    
    @IBAction func startWeek1() {
        let vc = storyboard?.instantiateViewController(identifier: "questionW1") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
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
