//
//  RankingViewController.swift
//  
//
//  Created by Viet Anh on 12/26/19.
//

import UIKit
import Firebase

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableViewUser: UITableView!
    
    var userName: String = ""
    
    private var userList = [UserModel]()
    private var test = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    private func getData() {
        userList.removeAll()
        
        let ref = Database.database().reference()
        ref.child("users").observe(.value) { (snapshot) in
            let dataUsers = snapshot.value as? [String : AnyObject] ?? [:]
            
            for user in dataUsers {
                guard let userDict = user.value as? [String : AnyObject] else { return }
                
                let uid = user.key
                let username = userDict["username"]!
                let scoreSetGame = userDict["scoreSetGame"]!
                let user = UserModel(uid: uid ,scoreSetGame: scoreSetGame as! Int, username: username as! String)
                
                self.userList.append(user)
            }
            
            self.userList.sort { (user1, user2) -> Bool in return user1.scoreSetGame > user2.scoreSetGame }
            self.tableViewUser.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingTableViewCell
        
        let user: UserModel = userList[indexPath.row]
        let currentUserID = Auth.auth().currentUser?.uid
        
        if user.uid == currentUserID {
            cell.labelName.text = String(indexPath.row+1) + ". " + user.username! + ": " + String(user.scoreSetGame) + "<--"
        }
        else {
            cell.labelName.text = String(indexPath.row+1) + ". " + user.username! + ": " + String(user.scoreSetGame)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
}
