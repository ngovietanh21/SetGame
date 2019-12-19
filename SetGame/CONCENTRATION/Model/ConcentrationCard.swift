//
//  ConcentrationCard.swift
//  SetGame
//
//  Created by Viet Anh on 11/19/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

// Model how the game work
// We are in model, you think Card have emoji but emoji is just a data
// so model do not own the data, we dont put emoji in here
// it just the way we display card, it in View and Controller down
// data source

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
