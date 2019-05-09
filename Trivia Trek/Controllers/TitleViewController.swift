//
//  TitleViewController.swift
//  MAD 2018-19
//
//  Created by Arthur Lafrance on 1/21/19.
//  Copyright © 2019 Homestead FBLA. All rights reserved.
//

import UIKit
import GameKit
import CloudKit
import SCSDKLoginKit
import FBSDKLoginKit
import SCSDKBitmojiKit
import FirebaseAuth

class TitleViewController: UIViewController {

    /// 4  main buttons on the screen
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var reportBug: UIButton!
    
    /// Profile area
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var avatarPicker: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    /// Facebook login button
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    var player: Player = Player()
    var avatarPickerShowing: Bool = false
    
    var avatarPickerController: AvatarPickerViewController?
    
    let goldColor = UIColor(red: 1, green: 0.8, blue: 0.196, alpha: 0.8).cgColor
    
    /// Configures settings when the apap first starts up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playButton.layer.cornerRadius = 15
        self.helpButton.layer.cornerRadius = 15
        self.progressButton.layer.cornerRadius = 15
        self.reportBug.layer.cornerRadius = 15
        self.loginButton.layer.cornerRadius = 15
        self.loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.avatarPicker.alpha = 0
        
        let fbLoginButton = FBSDKLoginButton(frame: CGRect(x: view.center.x - 60, y: view.center.y * 1.65, width: 120, height: 35))
    
        if UserDefaults.standard.hasObject(forKey: "bestScore") {
            
            let score = UserDefaults.standard.object(forKey: "bestScore") as! Int
            self.highScoreLabel.text = "Best Score: \(score == -1 ? "N/A" : "\(score)")"
            
        }
        else {
            
            self.highScoreLabel.text = "Best Score: N/A"

        }
        
        view.addSubview(fbLoginButton)
        
    }
    
    /// Refreshes the high score when the page appears (if there is a new high score)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.avatarButton.setImage(self.player.getAvatar(), for: .normal)
        
        if UserDefaults.standard.hasObject(forKey: "bestScore") {
            
            let score = UserDefaults.standard.object(forKey: "bestScore") as! Int
            self.highScoreLabel.text = "Best Score: \(score == -1 ? "N/A" : "\(score)")"
            
        }
        else {
            
            self.highScoreLabel.text = "Best Score: N/A"
            
        }

        let currentUser = Auth.auth().currentUser
        
        if currentUser == nil {
            self.usernameLabel.text = "Guest"
            self.loginButton.titleLabel!.text = "Log in"
        }
        else {
            self.usernameLabel.text = Auth.auth().currentUser?.displayName
            self.loginButton.titleLabel!.text = "Log out"
        }
        
    }

    /// Configures avatar picker view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is AvatarPickerViewController {
            
            let avatarPickerController = segue.destination as? AvatarPickerViewController
            self.avatarPickerController = avatarPickerController ?? nil
            self.avatarPickerController!.player = self.player
            self.avatarPickerController!.delegate = self
            
        }
        
    }
    
    @IBAction func doLogin(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        
        if user != nil {
            do {
                try Auth.auth().signOut()
                self.usernameLabel.text = "Guest"
            }
            catch {
                
            }
            
        }
        else {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
        
    }
    
    /// Facebook login completion
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        if ((error) != nil) {}
        else if result.isCancelled {}
        else { if result.grantedPermissions.contains("public_profile") {} }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    /// Show or remove the avatar picker
    @IBAction func toggleAvatarPicker(_ sender: Any) {

        if self.avatarPickerShowing {

            UIView.animate(withDuration: 1.2, animations: {
                self.avatarPicker.alpha = 0
            })

        }
        else {

            UIView.animate(withDuration: 1.2, animations: {
                self.avatarPicker.alpha = 1
            })

        }

        self.avatarButton.setImage(self.player.getAvatar(), for: .normal)
        self.avatarPickerShowing = !self.avatarPickerShowing

    }
    
    /// Placeholder function for the segue leading back to the title screen
    @IBAction func rewindToHome(segue: UIStoryboardSegue) {
        
        
    }

}
