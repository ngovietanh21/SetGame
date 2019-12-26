//
//  RankingViewController.swift
//  
//
//  Created by Viet Anh on 12/26/19.
//

import UIKit
import Firebase

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewUser: UITableView!
    
    var userName: String = ""
    
    private var userList = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    private func getData() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        collectionRef.getDocuments { (snapshot, err) in
            if let docs = snapshot?.documents {
                self.userList.removeAll()
                for docSnapshot in docs {
                    let username = docSnapshot["username"]!
                    let scoreSetGame = docSnapshot["scoreSetGame"]!
                    let user = UserModel(scoreSetGame: scoreSetGame as! Int, username: username as! String)
                    self.userList.append(user)
                }
                self.userList.sort { (user1, user2) -> Bool in
                    return user1.scoreSetGame > user2.scoreSetGame
                }
                self.tableViewUser.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingTableViewCell
        
        let user: UserModel = userList[indexPath.row]
        
        if user.username == userName {
            cell.labelName.text = String(indexPath.row+1) + ". " + "YOU - " + user.username! + ": " + String(user.scoreSetGame)
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
