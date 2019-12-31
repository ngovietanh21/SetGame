//
//  MenuViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/23/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    private var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTitle()
    }
    
    @IBAction private func onSignOutButton(_ sender: UIBarButtonItem) {
        signOut()
        comebackToLoginVC()
    }
    
    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("\nSignOut Successfully")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    private func comebackToLoginVC() {
        guard let loginNaviVC = storyboard?.instantiateViewController(identifier: Constant.Storyboard.loginNavigationController) as? MainNavigationViewController else { return; }
        
        view.window?.rootViewController = loginNaviVC
        present(loginNaviVC, animated: true)
    }
    
    private func setTitle() {
        if Auth.auth().currentUser != nil {
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("users").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                self.navigationItem.title = "Welcome: " + username
                self.userName = username
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIdentifier.showRanking {
            if let rankingVC = segue.destination as? RankingViewController {
                rankingVC.userName = self.userName
            }

        }
    }
    
}
