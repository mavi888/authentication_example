//
//  LoginViewController
//  authentication_example
//
//  Created by Marcia Villalba on 04/12/16.
//  Copyright © 2016 Marcia Villalba. All rights reserved.
//

import UIKit
import Lock
import SimpleKeychain

class LoginViewController: UIViewController {

    @IBOutlet weak var tokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let token = A0SimpleKeychain().string(forKey: "id_token") else {
            print("TOKEN is not here")
            return
        }
        print("token: " + token);
        
        guard A0SimpleKeychain().data(forKey: "user_profile") != nil else {
            print("PROFILE is not here")
            return
        }
    
        self.tokenLabel.text = "TOKEN AND PROFILE ARE HERE"
        self.showActionViewController();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        let controller = A0Lock.shared().newLockViewController()
        controller?.closable = true
        
        controller?.onAuthenticationBlock = {(profile, token) in
            guard let userProfile = profile else {
                self.showMissingProfileAlert()
                return
            }
            
            guard let userToken = token else {
                return
            }
            
            A0SimpleKeychain().setString(userToken.idToken, forKey: "id_token")
            let profileData = NSKeyedArchiver.archivedData(withRootObject: userProfile)
            A0SimpleKeychain().setData(profileData, forKey: "user_profile")

            self.retrievedProfile = userProfile
            controller?.dismiss(animated: true, completion: nil)
            
            self.showProfileViewController();
        }
        
        A0Lock.shared().present(controller, from: self)
        
    }
    
    // MARK: - Private
    
    fileprivate var retrievedProfile: A0UserProfile!
    
    fileprivate func showMissingProfileAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve profile", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showProfileViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyBoard.instantiateViewController(withIdentifier:"ProfileViewController") as! ProfileViewController
        profileViewController.profile = self.retrievedProfile
        self.present(profileViewController, animated: true, completion: nil)
    }
    
    fileprivate func showActionViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let actionViewController = storyBoard.instantiateViewController(withIdentifier:"ActionViewController") as! ActionViewController
        self.present(actionViewController, animated: true, completion: nil)
    }

}

