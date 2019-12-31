//
//  ChangeUsernameViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/31/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit
import Firebase

class ChangeUsernameViewController: UIViewController {
    
    @IBOutlet weak var newUsernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSaveButton(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil {
            //There's something wrong with the fields, show the error
            showError(error!)
        } else {
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let newUsername = newUsernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                if error != nil {
                    self.showError(error!.localizedDescription)
                } else {
                    var ref: DatabaseReference!
                    let userID = Auth.auth().currentUser?.uid
                    ref = Database.database().reference()
                    ref.child("users").child(userID!).updateChildValues(["username":newUsername!])
                    self.showError("Username change successfully.")
                }
            })
        }
        
        
    }
    
    
    private func validateFields() -> String? {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            newUsernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "You must fill everything!!!"
        }
        
        return nil
    }
    
    private func showError (_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
        errorLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
}
