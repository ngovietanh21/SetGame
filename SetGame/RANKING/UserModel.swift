//
//  UserModel.swift
//  SetGame
//
//  Created by Viet Anh on 12/26/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

class UserModel: Comparable {
    static func < (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.scoreSetGame < rhs.scoreSetGame
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.scoreSetGame == rhs.scoreSetGame
    }
    
    let scoreSetGame: Int
    let username: String?
    
    init(scoreSetGame: Int, username: String) {
        self.scoreSetGame = scoreSetGame
        self.username = username
    }
}
