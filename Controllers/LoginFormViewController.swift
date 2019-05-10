//
//  LoginFormViewController.swift
//  Trivia Trek
//
//  Created by Arthur Lafrance on 3/5/19.
//  Copyright © 2019 Homestead FBLA. All rights reserved.
//

import UIKit

class LoginFormViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.endEditing(true)
            return false
        }
        else {
            return true
        }
    }
}
