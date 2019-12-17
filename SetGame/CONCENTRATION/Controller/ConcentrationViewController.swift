//
//  ConcentrationViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/17/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    //MARK: - MODEL
    private lazy var game = ConcentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards : Int {
        return (cardButtons.count + 1) / 2
    }
    
    //When ever flipCount change, it gonna do this in didSet
    private(set) var flipCount = 0 { didSet { updateFlipCountLabel() } }
    
    //MARK: - VIEWS
    @IBOutlet private weak var flipCountLabel: UILabel! { didSet { updateFlipCountLabel() } }
    @IBOutlet private var cardButtons: [UIButton]!
    
    var theme: String? {
        didSet{
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
    private var emoji = [ConcentrationCard: String]()
    
    //MARK: - CONTROLLER
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender){
            if !game.cards[cardNumber].isMatched {
                flipCount += 1
            }
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        
    }
    
    //MARK: - UPDATE UI FROM MODEL
    
    func updateFlipCountLabel (){
        flipCountLabel.text = "Flips: \(flipCount)"
    }
    
    private func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                }
            }
        }
    }
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4randomNumber)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "!"
    }
}

extension Int {
    
    var arc4randomNumber: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
