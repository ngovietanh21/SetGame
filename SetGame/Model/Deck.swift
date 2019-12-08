//
//  Deck.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

class Deck
{
    private(set) var deck = [Card]()
    
    var count: Int {
        return deck.count
    }
    
    var isEmpty: Bool {
        return deck.isEmpty
    }
    
    func draw() -> Card {
        return deck.removeFirst()
    }
    
    init() {
        for number in Numbers.all {
            for color in Colors.all {
                for shape in Shapes.all {
                    for fill in Fills.all {
                        let card = Card(with: number, color, shape, fill)
                        deck += [card]
                    }
                }
            }
        }
        deck = deck.shuffled()
    }
}

extension Int {
    var randomNumber: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension Array {
    var shuffled: [Element] {
        var shuffledArray = [Element]()
        for element in self {
            shuffledArray.insert(element, at: shuffledArray.count.randomNumber)
        }
        return shuffledArray
    }
}
