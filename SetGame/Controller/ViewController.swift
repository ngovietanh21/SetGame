//
//  ViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    
    private var selectedCard = [CardView]()
    private var hintedCard = [CardView]()
    private var cardsOnScreen = [CardView]()
    private var cardsNeedAnimated = [CardView]()
    
    @IBOutlet private weak var setView: SetView!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var hintButton: UIButton!
    @IBOutlet private weak var setLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var deckButton: UIButton!
    
    
    @IBAction func onNewGameButton(_ sender: UIButton) {
        
    }
    
    @IBAction func onHintButton(_ sender: UIButton) {
        
    }
    
    @IBAction func onDeckButton(_ sender: UIButton) {
        
        
    }
    
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
}

