//
//  LoginViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/23/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passWordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func onLoginButton(_ sender: UIButton) {
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            //There's something wrong with the fields, show the error
            showError(error!)
            
        } else {
            //Signing in the user
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let passWord = passWordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email!, password: passWord!) { (result, error) in
                if error != nil {
                    self.showError(error!.localizedDescription)
                } else {
                    print("\nLogin Successfully")
                    self.comeToMenuVC()
                }
            }
            
        }
        
    }

    
    private func validateFields() -> String? {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passWordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "You must fill everything!!!"
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
