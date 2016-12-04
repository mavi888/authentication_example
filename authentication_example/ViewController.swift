//
//  ViewController.swift
//  authentication_example
//
//  Created by Marcia Villalba on 04/12/16.
//  Copyright © 2016 Marcia Villalba. All rights reserved.
//

import UIKit
import Lock

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        let controller = A0Lock.shared().newLockViewController()
        
        controller?.closable = true
        controller?.onAuthenticationBlock = {(profile, token) in
            // Do something with token & profile. e.g.: save them.
            // Lock will not save the Token and the profile for you.
            // And dismiss the UIViewController.
            self.dismiss(animated: true, completion: nil)
        }
        
        A0Lock.shared().present(controller, from: self)
    }
}

