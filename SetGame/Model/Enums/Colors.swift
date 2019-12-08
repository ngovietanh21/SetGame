//
//  Colors.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

enum Colors: Int
{
    case red = 1
    case green
    case blue
    
    static var all = [Colors.red,.green,.blue]
    
}

extension Colors: CustomStringConvertible {
    var description: String {
        switch self {
        case .red: return "red"
        case .green: return "green"
        case .blue: return "blue"
        }
    }
}
