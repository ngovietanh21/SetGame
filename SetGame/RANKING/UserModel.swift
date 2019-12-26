//
//  UserModel.swift
//  SetGame
//
//  Created by Viet Anh on 12/26/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

class UserModel{
    let uid: String
    let scoreSetGame: Int
    let username: String?
    
    init(uid: String,scoreSetGame: Int, username: String) {
        self.uid = uid
        self.scoreSetGame = scoreSetGame
        self.username = username
    }
}
