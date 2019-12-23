//
//  SetGame.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import Foundation

class SetGame
{
    //MARK: - VARIABLES
    var deck = Deck()
    var cardsOnTable = [SetCard]()
    var selectedCards = [SetCard]()
    var setCards = [SetCard]()
    var hintCard = [Int]()
    
    var score = 0
    
    private var numberOfInitialCardsOnTable = 12
    
    init(){
        for _ in 1...numberOfInitialCardsOnTable {
            cardsOnTable.append(deck.draw())
        }
    }
    
    //MARK: - GAME ACTIONS
    //SELECT A CARD ON TABLE
    func chooseCard (at index: Int){
        if index >= cardsOnTable.count {
            return
        }
        
        let chosenCard = cardsOnTable[index]
        
        //DESELECT IF < 3
        //Guard tức là đảm bảo rằng nếu không thì { return }
        guard !(selectedCards.contains(chosenCard) && selectedCards.count < 3) else {
            selectedCards.remove(at: selectedCards.firstIndex(of: chosenCard)!)
            return
        }
        
        //SELECT CARD
        selectedCards.append(chosenCard)
        
        if selectedCards.count == 3 {
             //CHECK FOR SET
            if isSet(on: selectedCards) {
                setCards += selectedCards
                replaceSetCards()
                score += 3
            } else {
                score -= 3
            }
        }
        
        if selectedCards.count == 4 {
            selectedCards = [chosenCard]
        }
    }
    
    func replaceSetCards() {
        let drawCard = drawThreeCard()
        for index in selectedCards.indices {
            let removeIndex = cardsOnTable.firstIndex(of: selectedCards[index])!
            if drawCard.count > 0 {
                cardsOnTable[removeIndex] = drawCard[index]
            } else {
                cardsOnTable.remove(at: removeIndex)
            }
            
        }
    }
    
    func drawThreeCardsToTable(){
        if !deck.isEmpty {

            for _ in 1...3 {
                let card = deck.draw()
                cardsOnTable.append(card)
            }
        }
    }
    
    func drawThreeCard() -> [SetCard]{
        if deck.count > 0 {
            var drawCards = [SetCard]()
            for _ in 1...3 {
                let card = deck.draw()
                drawCards.append(card)
            }
            return drawCards
        }
        return []
    }
    
    func hint() {
        hintCard.removeAll()
        for i in 0..<cardsOnTable.count {
            for j in (i + 1)..<cardsOnTable.count {
                for k in (j + 1)..<cardsOnTable.count {
                    let hints = [cardsOnTable[i], cardsOnTable[j], cardsOnTable[k]]
                    if isSet(on: hints) {
                        hintCard += [i, j, k]
                    }
                }
            }
        }
    }
    
    func isOver() -> Bool {
        hint()
        return deck.count == 0 && hintCard.count == 0
    }
    
    // MARK: - ALGORITHMS
    func isSet (on selectedCards: [SetCard]) -> Bool {
        if selectedCards.count < 3 { return false }
        
        let color = Set(selectedCards.map {$0.color}).count
        let fill = Set(selectedCards.map {$0.fill}).count
        let number = Set(selectedCards.map {$0.number}).count
        let shape = Set (selectedCards.map{$0.shape}).count
        
        return color != 2 && shape != 2 && number != 2 && fill != 2
    }
}
