//
//  Fills.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

enum Fills
{
    case solid
    case stripe
    case empty
    
    static var all = [Fills.solid,.stripe,.empty]
    
}

extension Fills: CustomStringConvertible {
    var description: String {
        switch self {
        case .solid: return "solid"
        case .stripe: return "stripe"
        case .empty: return "empty"
        }
    }
}

