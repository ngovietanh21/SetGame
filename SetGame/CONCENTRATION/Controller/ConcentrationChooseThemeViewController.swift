//
//  ConcentrationChooseThemeViewController.swift
//  SetGame
//
//  Created by Viet Anh on 12/5/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit

class ConcentrationChooseThemeViewController: UIViewController {
    
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals": "🐶🦆🐹🐸🐘🦍🐓🐩🐦🦋🐙🐏",
        "Faces": "😀😌😎🤓😠😤😭😰😱😳😜😇"
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIdentifier.chooseTheme {
            if let button = sender as? UIButton {
                if let themeName = button.currentTitle, let theme = themes[themeName] {
                    if let cvc = segue.destination as? ConcentrationViewController {
                        cvc.theme = theme
                    }
                    
                }
            }
        }
    }
    
    
}
