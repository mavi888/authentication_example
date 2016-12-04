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
            guard let userProfile = profile else {
                self.showMissingProfileAlert()
                return
            }
            
            guard let userToken = token else {
                return
            }
            
            let keychain = A0SimpleKeychain(service: "Auth0")
            keychain.setString(userToken.idToken, forKey: "id_token")
            
            self.retrievedProfile = userProfile
            controller?.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "ShowProfile", sender: nil)
        }
        
        A0Lock.shared().present(controller, from: self)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileController = segue.destination as? ProfileViewController else {
            return
        }
        profileController.profile = self.retrievedProfile
    }
    
    // MARK: - Private
    
    fileprivate var retrievedProfile: A0UserProfile!
    
    fileprivate func showMissingProfileAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve profile", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

