//
//  ViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit
import Firebase

class SetGameViewController: UIViewController {
    
    //MARK: - MODEL
    private var game = SetGame()
    
    //MARK: - VIEWS
    private var selectedCard = [SetCardView]()
    private var hintedCard = [SetCardView]()
    private var cardsOnScreen = [SetCardView]()
    
    @IBOutlet private weak var setView: SetView!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var hintButton: UIButton!
    @IBOutlet private weak var setLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var deckButton: UIButton!
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        game = SetGame()
        updateCardsOnScreen()
        updateNumberOfCardOnDeck()
        updateNumberOfSetCard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCardsOnScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            saveScore()
        }
    }
    
    //MARK: - CONTROLLER
    @IBAction private func onNewGameButton(_ sender: UIButton) {
       newGame()
    }
    
    @IBAction private func onHintButton(_ sender: UIButton) {
        hintedCard.removeAll()
        
        if game.hintCard.count < 3 { return }
        for index in 0...2 {
            hintedCard.append(cardsOnScreen[game.hintCard[index]])
            cardsOnScreen[game.hintCard[index]].state = .hinted
            cardsOnScreen[game.hintCard[index]].setNeedsDisplay()
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] timer in
            for index in 0...2 {
                self!.cardsOnScreen[self!.game.hintCard[index]].state = .unselected
                self!.cardsOnScreen[self!.game.hintCard[index]].setNeedsDisplay()
                
            }
        }
    }
    
    @IBAction private func onDeckButton(_ sender: UIButton) {
        game.drawThreeCardsToTable()
        updateNumberOfCardOnDeck()
        updateCardsOnScreen()
    }
    
    //MARK: - UPDATE UI FROM MODEL
    
    private func newGame() {
        game = SetGame()
        updateCardsOnScreen()
        updateScore()
        updateNumberOfCardOnDeck()
        updateNumberOfSetCard()
    }
    
    private func updateScore() {
          scoreLabel.text = "Score: \(game.score)"
    }
    
    private func updateNumberOfCardOnDeck() {
        deckButton.isEnabled = true
        deckButton.setTitle("Deck: "+String(game.deck.count), for: .normal)
        if game.deck.count == 0 {
            deckButton.isEnabled = false
        }
    }
    
    private func updateNumberOfSetCard() {
        setLabel.text = "Set: \(game.setCards.count/3)"
    }
    
    private func updateCardsOnScreen() {
        cardsOnScreen.forEach { $0.removeFromSuperview() }
        cardsOnScreen.removeAll()
        
        let grid = SetGrid(for: setView.bounds, withNoOfFrames: game.cardsOnTable.count)
        for index in game.cardsOnTable.indices {
            cardsOnScreen.append(SetCardView(frame: grid[index]!, card: game.cardsOnTable[index]))
            setView.addSubview(cardsOnScreen[index])
            cardsOnScreen[index].contentMode = .redraw
            cardsOnScreen[index].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCard(_:))))
            
        }
        if game.isOver() {
            let alert = UIAlertController(title: "Game Over", message: "Cannot Find Any Set", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { action in self.newGame() }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func tapCard(_ recognizer: UITapGestureRecognizer) {
        
        if let tappedCard = recognizer.view as? SetCardView {
            if let index = cardsOnScreen.firstIndex(of: tappedCard), index < game.cardsOnTable.count  {
                game.chooseCard(at: index)
                if let state = tappedCard.state {
                    switch state {
                    case .selected:
                        tappedCard.state = .unselected
                        selectedCard.remove(at: selectedCard.firstIndex(of: tappedCard)!)
                    case .unselected:
                        tappedCard.state = .selected
                        selectedCard.append(tappedCard)
                    default:
                        break
                    }
                }
                tappedCard.setNeedsDisplay()
                
                if selectedCard.count == 3  {
                    if game.isSet(on: game.selectedCards) {
                        updateNumberOfSetCard()
                        updateNumberOfCardOnDeck()
                        
                    } else {
                        cardsOnScreen.forEach() {
                            $0.state = .unselected
                            $0.setNeedsDisplay()
                        }
                    }
                    selectedCard.removeAll()
                    game.selectedCards.removeAll()
                    updateScore()
                }
            }
        }
        
    }
    
    //MARK: -  SAVE SCORE GAME
    private func saveScore() {
        if Auth.auth().currentUser != nil {
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("users").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let score = value?["scoreSetGame"] as? Int ?? 1
                if score < self.game.score {
                    ref.child("users/\(userID!)/scoreSetGame").setValue(self.game.score)
                }
            }
        }
    }
    

}

