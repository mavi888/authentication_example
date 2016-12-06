//
//  ProfileViewController.swift
//  authentication_example
//
//  Created by Marcia Villalba on 04/12/16.
//  Copyright © 2016 Marcia Villalba. All rights reserved.
//

import UIKit
import Lock
import SimpleKeychain

class ProfileViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var profile: A0UserProfile!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.profile == nil) {
            let data = A0SimpleKeychain().data(forKey: "user_profile")
            profile = NSKeyedUnarchiver.unarchiveObject(with: data!) as! A0UserProfile!
        }
        
        self.welcomeLabel.text = "Welcome, \(self.profile.name)"
        URLSession.shared.dataTask(with: self.profile.picture, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data , error == nil else { return }
                self.avatarImageView.image = UIImage(data: data)
            }
        }).resume()
    }
}
