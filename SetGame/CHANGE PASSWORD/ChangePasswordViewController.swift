//
//  ChangePasswordViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/25/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var currentPasswordField: UITextField!
    @IBOutlet private weak var newPasswordField: UITextField!
    @IBOutlet private weak var confirmNewPasswordField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func onSaveButton(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil {
            //There's something wrong with the fields, show the error
            showError(error!)
        } else {
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let currentPassword = currentPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let newPassword = newPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let credential = EmailAuthProvider.credential(withEmail: email!, password: currentPassword!)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                if error != nil {
                    self.showError(error!.localizedDescription)
                } else {
                    Auth.auth().currentUser?.updatePassword(to: newPassword!, completion: { (error) in
                        if error != nil {
                            self.showError(error!.localizedDescription)
                        } else {
                            self.showError("Password change successfully.")
                        }
                    })
                }
            })
        }
        
        
    }
    
    private func validateFields() -> String? {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            currentPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            newPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmNewPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "You must fill everything!!!"
        }
        
        if newPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != confirmNewPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "Check again password!!"
        }
        
        return nil
    }
    
    private func showError (_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
        errorLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
}
