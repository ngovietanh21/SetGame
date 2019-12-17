//
//  Numbers.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

enum Numbers
{
    case one
    case two
    case three
    
    static var all = [Numbers.one,.two,.three]
}

extension Numbers: CustomStringConvertible {
    var description: String {
        switch self {
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        }
    }
}
