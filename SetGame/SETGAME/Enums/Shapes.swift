//
//  Shapes.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

enum Shapes
{
    case circle
    case square
    case triangle
    
    
    static var all = [Shapes.circle,.square,.triangle]
    
}

extension Shapes: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .circle: return "circle"
        case .square: return "square"
        case .triangle: return "triangle"
        }
    }
}
