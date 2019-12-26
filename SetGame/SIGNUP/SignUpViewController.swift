//
//  SignUpViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/24/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var userNameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var confirmPasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction private func onSignUpButton(_ sender: UIButton) {
        
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            //There's something wrong with the fields, show the error
            showError(error!)
            
        } else {
            let username = userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the user
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, err) in
                
                //Check for error
                if err != nil {
                    //There was an error creating an user
                    self.showError("Error creating user")
                    
                } else {
                    //User was created succesfully, now store the username
                    let db = Firestore.firestore()
                    db.collection("users").document(authResult!.user.uid).setData(["username":username!,"scoreSetGame":0]) { err in
                        
                        if err != nil {
                            //Show error
                            self.showError("Some thing wrong in saving data")
                        }
                        
                    }
                    //Comeback to login screen
                    print("\nSignUp Successfully")
                    self.comeToMenuVC()
                }
                
            }
            
            
        }
        
    }
    
    
    private func validateFields() -> String? {
        if userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "You must fill everything!!!"
        }
        
        if passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "Check again password!!"
        }
        
        return nil
    }
    
    private func showError (_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
        errorLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
    private func comeToMenuVC() {
        guard let menuNaviVC = storyboard?.instantiateViewController(identifier: Constant.Storyboard.menuNavigationController) as? MenuNavigationViewController else { return; }
        
        view.window?.rootViewController = menuNaviVC
        present(menuNaviVC, animated: true)
    }
    
}

