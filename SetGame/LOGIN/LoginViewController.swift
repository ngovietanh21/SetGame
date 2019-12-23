//
//  LoginViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/23/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var userNameField: UITextField!
    @IBOutlet private weak var passWordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func onLoginButton(_ sender: UIButton) {
        let userName = userNameField.text
        let passWord = passWordField.text
        
        if userName == "" || passWord == "" {
            let alert = UIAlertController(title: "Warning", message: "Enter your username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in  })

            self.present(alert, animated: true, completion: nil)
        } else {
           navigateToMainInterface()
        }
    }
    
    private func navigateToMainInterface() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainNavigate = mainStoryboard.instantiateViewController(identifier: "Main NavigationViewController") as? MainNavigationViewController else { return; }
        
        if let menuVC = mainNavigate.topViewController as? MenuViewController {
            menuVC.userName = userNameField.text
            menuVC.passWord = passWordField.text
        }
        
        present(mainNavigate, animated: true)
    }
}
