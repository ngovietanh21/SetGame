//
//  Card.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

struct Card
{
    let number: Numbers
    let color: Colors
    let shape: Shapes
    let fill: Fills
    

    init(with n: Numbers, _ c: Colors, _ s: Shapes, _ f: Fills) {
        number = n
        color = c
        shape = s
        fill = f
    }

}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color &&
            lhs.fill == rhs.fill &&
            lhs.number == rhs.number &&
            lhs.shape == rhs.shape
    }
    
}

extension Card: CustomStringConvertible {
    var description: String {
        return "\(number)_\(color)_\(shape)_\(fill)"
    }
}
