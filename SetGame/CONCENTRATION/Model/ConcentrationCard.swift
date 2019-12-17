//
//  ConcentrationCard.swift
//  SetGame
//
//  Created by Viet Anh on 12/17/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation
struct ConcentrationCard: Hashable
{
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    private static var identifierFactory = 0;
    
    func hash(into hasher: inout Hasher){
        return hasher.combine(identifier)
    }
    
    
    static func == (lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
}
