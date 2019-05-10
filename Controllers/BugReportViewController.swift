//
//  BugReportViewController.swift
//  MAD 2018-19
//
//  Created by Samrudh Shenoy on 2/12/19.
//  Copyright © 2019 Homestead FBLA. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BugReportViewController: UIViewController, UITextViewDelegate {
    
    /// Field where the user enters their description
    @IBOutlet weak var textField: UITextView!
    
    /// Submits the text to our online databases
    @IBOutlet weak var submitButton: UIButton!
    
    /// Cancels and returns to the home screen
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.layer.cornerRadius = 10
        self.textField.layer.masksToBounds = true
        self.textField.layer.borderColor = UIColor.darkGray.cgColor
        self.textField.layer.borderWidth = 2
        self.textField.keyboardType = UIKeyboardType.default
        self.textField.clearsOnInsertion = true
        self.textField.resignFirstResponder()
        self.textField.delegate = self
        
        self.submitButton.layer.cornerRadius = 15
        self.cancelButton.layer.cornerRadius = 15
        
    }
    
    /// Submits user-entered text into our database
    @IBAction func submitButton(_ sender: Any) {
        
        // do the query
        let db = Firestore.firestore()
        
        let data: [String : Any] = ["user" : Auth.auth().currentUser?.uid,
                                    "description" : self.textField.text]
        
        db.collection("bugs").addDocument(data: data, completion: { error in
            var message = ""
            var description = ""
            
            if error != nil {
                message = "Error"
                description = error!.localizedDescription
            }
            else {
                message = "Success"
                description = "Feedback reported successfully"
            }
            
            let alertScreen = UIAlertController(title: message, message: description, preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default, handler: { action in
                self.rewindToHome(self)
            })
            alertScreen.addAction(action)
            
            self.present(alertScreen, animated: true, completion: {})
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Returns to the title screen
    @IBAction func rewindToHome(_ sender: Any) {
        
        self.performSegue(withIdentifier: "rewindToHome", sender: self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            self.textField.endEditing(true)
            return false
        }
        else {
            return true
        }
    }
    
}
