//
//  ViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {
    
    //MARK: - MODEL
    private var game = SetGame()
    
    //MARK: - VIEWS
    private var selectedCard = [SetCardView]()
    private var hintedCard = [SetCardView]()
    private var cardsOnScreen = [SetCardView]()
    private var cardsNeedAnimated = [SetCardView]()
    
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
        updateCardsOnTable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let grid = SetGrid(for: setView.bounds, withNoOfFrames: game.cardsOnTable.count)
        for index in cardsOnScreen.indices {
            cardsOnScreen[index].frame = grid[index]!
            cardsOnScreen[index].setNeedsDisplay()
        }
    }
    
    
    //MARK: - CONTROLLER
    @IBAction private func onNewGameButton(_ sender: UIButton) {
        cardsOnScreen.forEach { $0.removeFromSuperview() }
        cardsOnScreen.removeAll()
        selectedCard.removeAll()
        hintedCard.removeAll()
        
        game = SetGame()
        updateCardsOnTable()
        updateScore()
        updateNumberOfCardOnDeck()
        updateNumberOfSetCard()
    }
    
    @IBAction private func onHintButton(_ sender: UIButton) {
        game.hint()
        hintedCard.removeAll()
        
        if game.hintCard.count < 3 { return }
        for index in 0...2 {
            hintedCard.append(cardsOnScreen[game.hintCard[index]])
            cardsOnScreen[game.hintCard[index]].state = .hinted
            cardsOnScreen[game.hintCard[index]].setNeedsDisplay()
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] timer in
            for index in 0...2 {
                self!.cardsOnScreen[self!.game.hintCard[index]].state = .unselected
                self!.cardsOnScreen[self!.game.hintCard[index]].setNeedsDisplay()
                
            }
        }
    }
    
    @IBAction private func onDeckButton(_ sender: UIButton) {
        game.drawThreeCardsToTable()
        smallCardOnScreen()

        cardsNeedAnimated.removeAll()
        let indexOfLastThreeCardOnTable = game.cardsOnTable.count - 3
        
        let drawCard = setView.convert(deckButton.bounds, from: deckButton)
        for index in indexOfLastThreeCardOnTable..<game.cardsOnTable.count {
            let cards = SetCardView(frame: drawCard, card: game.cardsOnTable[index])
            cards.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCard(_:))))
            setView.addSubview(cards)
            cardsNeedAnimated.append(cards)
            cardsOnScreen.append(cards)
        }
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(flyIn), userInfo: nil, repeats: false)
        
    }

    
    //MARK: - UPDATE UI FROM MODEL
    private func updateScore() {
          scoreLabel.text = "Score: \(game.score)"
    }
    
    private func updateNumberOfCardOnDeck() {
        deckButton.setTitle("Deck: "+String(game.deck.count), for: .normal)
        if game.deck.count == 0 {
            deckButton.isEnabled = false
        }
    }
    
    private func updateNumberOfSetCard() {
        setLabel.text = "Set: \(game.setCards.count/3)"
    }
    
    private func updateCardsOnTable() {
        cardsOnScreen.removeAll()
        cardsNeedAnimated.removeAll()
        
        for index in game.cardsOnTable.indices {
            let drawCard = setView.convert(deckButton.bounds, from: deckButton)
            cardsOnScreen.append(SetCardView(frame: drawCard, card: game.cardsOnTable[index]))
            setView.addSubview(cardsOnScreen[index])
            cardsOnScreen[index].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCard(_:))))
            cardsNeedAnimated.append(cardsOnScreen[index])
        }
        flyIn()
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
                        flayAway()
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
    
    //MARK: -  ANIMATION
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    
    @objc private func flyIn() {
        
        let grid = SetGrid(for: setView.bounds, withNoOfFrames: game.cardsOnTable.count)
        
        for timeOfAnimate in 0..<cardsNeedAnimated.count {
            let gridIndex = cardsOnScreen.firstIndex(of: cardsNeedAnimated[timeOfAnimate])
            let delayTime = 0.3 * Double(timeOfAnimate)
            
            UIView.animate(withDuration: 1,
                           delay: delayTime,
                           options: .curveEaseInOut,
                           animations: {
                            self.deckButton.isUserInteractionEnabled = false
                            self.cardsNeedAnimated[timeOfAnimate].frame = grid[gridIndex!]!
                            
            },
                           completion: { finish in
                            UIView.transition(with: self.cardsNeedAnimated[timeOfAnimate],
                                              duration: 0.3,
                                              options: .transitionFlipFromLeft,
                                              animations: {
                                                self.cardsNeedAnimated[timeOfAnimate].isFaceUp = true
                                                self.cardsNeedAnimated[timeOfAnimate].setNeedsDisplay()
                                                
                            }, completion: { finish in
                                if timeOfAnimate == self.cardsNeedAnimated.endIndex - 1 {
                                    self.deckButton.isUserInteractionEnabled = true
                                }
                            })
            })
        }
        
        updateNumberOfCardOnDeck()
    }
    
    
    private func flayAway() {
        let flyBehavior = Flyaway(in: animator)
        var flyAwayCards = [SetCardView]()
        
        selectedCard.forEach {
            let index = cardsOnScreen.firstIndex(of: $0)
            let card = SetCardView(frame: $0.frame, card: game.cardsOnTable[index!])
            card.isFaceUp = true
            flyAwayCards.append(card)
            setView.addSubview(card)
        }
        
         selectedCard.forEach() {
             $0.alpha = 0
         }
         
         flyAwayCards.forEach() {
             flyBehavior.addItem($0)
         }
         
         for cards in flyAwayCards {
             UIView.animate(withDuration: 0.7, animations: { cards.alpha = 0  })
         }
        
         putCardIntoScreen()
        
     }
     
    private func putCardIntoScreen() {
        
        var isNeedSmall = false
        let dealToStView = setView.convert(deckButton.bounds, from: deckButton)
        if cardsNeedAnimated.count != 0 { cardsNeedAnimated = [] }
        
        selectedCard.forEach {
            
            let index = cardsOnScreen.firstIndex(of: $0)!
            let card = cardsOnScreen[index]
            if game.deck.count > 0 || game.cardsOnTable.count == cardsOnScreen.count {
                cardsOnScreen[index] = SetCardView(frame: dealToStView, card: game.cardsOnTable[index])
                card.removeFromSuperview()
                setView.addSubview(cardsOnScreen[index])
                cardsOnScreen[index].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCard(_:))))
                cardsNeedAnimated.append(cardsOnScreen[index])
            } else {
                $0.removeFromSuperview()
                cardsOnScreen.remove(at: cardsOnScreen.firstIndex(of: $0)!)
                isNeedSmall = true
            }
        }
        updateNumberOfCardOnDeck()
        if isNeedSmall {
            smallCardOnScreen()
        } else {
            flyIn()
        }
    }
    
    private func smallCardOnScreen() {
        let grid = SetGrid(for: setView.frame, withNoOfFrames: game.cardsOnTable.count)
        for index in cardsOnScreen.indices  {
            UIView.transition(with: cardsOnScreen[index],
                              duration: 0.7,
                              options: .allowAnimatedContent,
                              animations: {
                                self.deckButton.isUserInteractionEnabled = false
                                let scaleY = grid[index]!.height / self.cardsOnScreen[index].frame.height
                                let scaleX = grid[index]!.width / self.cardsOnScreen[index].frame.width
                                self.cardsOnScreen[index].transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                                
                              },
                              completion: { finished in
                                UIView.animate(withDuration: 0.5,
                                               animations: {
                                                self.cardsOnScreen[index].frame = grid[index]!
                                                self.cardsOnScreen[index].setNeedsDisplay(grid[index]!)
                                                if index == self.cardsOnScreen.endIndex - 1 {
                                                    self.deckButton.isUserInteractionEnabled = false
                                                }
                                })
            })
        }
    }
    
}

