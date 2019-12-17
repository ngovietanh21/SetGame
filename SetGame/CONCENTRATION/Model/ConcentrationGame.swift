//
//  ConcentrationGame.swift
//  SetGame
//
//  Created by Viet Anh on 12/17/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

class ConcentrationGame
{
    private(set) var cards = [ConcentrationCard]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            //demo a closure and extension protocol
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
            //            let faceUpCardIndices = cards.indices.filter{cards[$0].isFaceUp}
            //            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
            
            //            var foundIndex : Int?
            //            for index in cards.indices {
            //                if cards[index].isFaceUp {
            //                    if foundIndex == nil {
            //                        foundIndex = index
            //                    } else {
            //                        return nil
            //                    }
            //                }
            //            }
            //            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        //if someone set chooseCard ai index like -1 or 100 but infact we just have 12 cards, so we should protect API by showing the message
        assert(cards.indices.contains(index), "Concentration.chooseCard (at: \(index)): choosen index not in the cards ")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
            
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init (\(numberOfPairsOfCards)): you must have at least one pair of card")
        for _ in 1...numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card,card]
        }
        
        cards.shuffle()
    }
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
