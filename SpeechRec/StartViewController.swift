//
//  StartViewController.swift
//  SpeechRec
//
//  Created by 本田彩 on 2021/05/11.
//  Copyright © 2021 本田彩. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class StartViewController: UIViewController {

    @IBOutlet weak var UUIDLabel: UILabel!
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UUIDLabel.text = "ID:\(String(describing: UIDevice.current.identifierForVendor!.uuidString))"
    }
    
    @IBAction func startWeek1() {
        
        let vc = storyboard?.instantiateViewController(identifier: "questionW1") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    

    
    @IBAction func startWeek2() {
        
        var result = PFObject(className:"start")
            result["uuid"] = uuid
            result["WeekNo"] = "W2"
            result.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                    
                }
                
            }
        
        
        let vc = storyboard?.instantiateViewController(identifier: "questionW2") as! W2ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
       
        
    }
    
    @IBAction func startWeek3() {
        
        var result = PFObject(className:"start")
            result["uuid"] = uuid
            result["WeekNo"] = "W3"
            result.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                    
                }
                
            }
        
    
        let vc = storyboard?.instantiateViewController(identifier: "questionW3") as! W3ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
        
        
    }
    
    @IBAction func startTest() {
        
        let vc = storyboard?.instantiateViewController(identifier: "questionTest") as! TestViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    @IBAction func startWeek1Red() {
        
        let vc = storyboard?.instantiateViewController(identifier: "questionW1R") as! W1RViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    @IBAction func startWeek2Red() {
        
        var result = PFObject(className:"start")
            result["uuid"] = uuid
            result["WeekNo"] = "W2R"
            result.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                    
                }
                
            }
        
        let vc = storyboard?.instantiateViewController(identifier: "questionW2R") as! W2RViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    @IBAction func startWeek3Red() {
        
        var result = PFObject(className:"start")
            result["uuid"] = uuid
            result["WeekNo"] = "W3R"
            result.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                    
                }
                
            }
        
        let vc = storyboard?.instantiateViewController(identifier: "questionW3R") as! W3RViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    @IBAction func startWeek1Blue() {
        
        let vc = storyboard?.instantiateViewController(identifier: "questionW1B") as! W1BViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    @IBAction func startWeek2Blue() {
        
        var result = PFObject(className:"start")
            result["uuid"] = uuid
            result["WeekNo"] = "W2B"
            result.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                    
                }
                
            }
        
        let vc = storyboard?.instantiateViewController(identifier: "questionW2B") as! W2BViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    @IBAction func startWeek3Blue() {
        
        var result = PFObject(className:"start")
            result["uuid"] = uuid
            result["WeekNo"] = "W3B"
            result.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                    
                }
                
            }
        
        let vc = storyboard?.instantiateViewController(identifier: "questionW3B") as! W3BViewController
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
