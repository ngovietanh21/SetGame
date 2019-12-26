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
    
    @IBAction func onSignOutButton(_ sender: UIBarButtonItem) {
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
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userID!)
            ref.getDocument { (snapshot, err) in
                if let data = snapshot?.data() {
                    guard let username = data["username"] as? String else { return }
                    self.navigationItem.title = "Welcome: " + username
                    self.userName = username
                }
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
