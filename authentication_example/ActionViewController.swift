//
//  ActionViewController.swift
//  authentication_example
//
//  Created by Marcia Villalba on 09/12/16.
//  Copyright © 2016 Marcia Villalba. All rights reserved.
//

import UIKit
import Lock
import SimpleKeychain

class ActionViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var responseLabel: UILabel!
    
    var profile: A0UserProfile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        if (self.profile == nil) {
            let data = A0SimpleKeychain().data(forKey: "user_profile")
            profile = NSKeyedUnarchiver.unarchiveObject(with: data!) as! A0UserProfile!
        }
        
        self.nameLabel.text = "Welcome, \(self.profile.name)"
        URLSession.shared.dataTask(with: self.profile.picture, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data , error == nil else { return }
                self.profileImage.image = UIImage(data: data)
            }
        }).resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickLogout(_ sender: Any) {
        A0SimpleKeychain().deleteEntry(forKey: "id_token")
        A0SimpleKeychain().deleteEntry(forKey: "user_profile")
        
        self.showLoginViewController();
    }
    
    @IBAction func actionClicked(_ sender: Any) {
        self.callActionRequest()
    }
    
    // MARK: - Private
    
    fileprivate func showLoginViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier:"LoginViewController") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    fileprivate func callActionRequest() {
        // Define server side script URL
        let actionURL = "https://aos6iy1cfc.execute-api.us-east-1.amazonaws.com/dev/users/create"
        
        // Create NSURL Object
        let myUrl = NSURL(string: actionURL);
        
        // Create URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        //Single Authorization Token value
        let token = A0SimpleKeychain().string(forKey: "id_token")
        request.addValue(token!, forHTTPHeaderField: "Authorization")
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            DispatchQueue.global(qos: .userInitiated).async{
                DispatchQueue.main.async {
                    self.responseLabel.text = responseString as String?
                }
            }
        }
        task.resume()
    }
}
