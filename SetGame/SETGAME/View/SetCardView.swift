//
//  CardView.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    var state: States?
    var card: SetCard?
    var isFaceUp: Bool
    
    private var color: Colors?{
        return card?.color
    }
    
    private var shape: Shapes? {
        return card?.shape
    }
    
    private var number: Numbers? {
        return card?.number
    }
    
    private var fill: Fills? {
        return card?.fill
    }
    
    override init(frame: CGRect) {
        isFaceUp = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        isFaceUp = false
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, card: SetCard) {
        self.init(frame: frame)
        self.card = card
        self.state = .unselected
        backgroundColor = backGroundColorOfSetCard
    }
    
    private var objectFrame: [CGRect] {
        var frames = [CGRect]()
        guard let number = number else { return []}
        var y = spaceBetweenObject
        // first object
        var objectFrame = CGRect(x: marginToObject, y: y, width: heightOfObject, height: heightOfObject)
        frames.append(objectFrame)
        
        // second and third if there is one
        for _ in 1..<number.rawValue {
            y += (spaceBetweenObject + heightOfObject)
            objectFrame = CGRect(x: marginToObject, y: y, width: heightOfObject, height: heightOfObject)
            frames.append(objectFrame)
        }
        return frames
    }
    
    private func drawObject() {
        for object in subviews {
            object.removeFromSuperview()
        }
        if let number = number?.rawValue {
            for index in 0..<number {
                if let shape = shape, let color = color, let fill = fill {
                    
                    let object = ObjectView(frame: objectFrame[index], shape: shape, color: color, fill: fill)
                    
                    addSubview(object)
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if isFaceUp {
            drawObject()
            
            let boarder = UIBezierPath(roundedRect:
                CGRect(x: bounds.origin.x,
                       y: bounds.origin.y,
                       width: bounds.width,
                       height: bounds.height),cornerRadius: cornerRadius)
            
            backGroundColorOfSetCard.setFill()
            boarder.fill()
            
            if let state = state {
                switch state {
                case .hinted:
                    boarder.lineWidth = hintedBoarderWidth
                case .selected:
                    boarder.lineWidth = selectedBoarderWidth
                case .unselected:
                    boarder.lineWidth = unselectedBoarderWidth
                }
            }
            
            boarderColor.setStroke()
            boarder.stroke()
            
        } else {
            let back = UIBezierPath(rect: bounds)
            #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).setFill()
            back.fill()
        }
        
    }
    
}

enum States {
    case selected
    case unselected
    case hinted
}


extension SetCardView {
    private var unselectedBoarderWidth: CGFloat {
        return 1
    }
    
    private var selectedBoarderWidth: CGFloat {
        return 5
    }
    
    private var hintedBoarderWidth: CGFloat {
        return 8
    }
    
    private var backGroundColorOfSetCard: UIColor {
        return #colorLiteral(red: 0.9990555644, green: 1, blue: 0.9045438766, alpha: 1)
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * 0.04
    }
    
    private var heightOfObject: CGFloat {
        return bounds.height / 4
    }
    
    private var marginToObject: CGFloat {
        return bounds.midX - heightOfObject / 2
    }
    
    private var boarderColor: UIColor {
        if let state = state {
            switch state {
            case .hinted:
                return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            case .selected:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case .unselected:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    private var spaceBetweenObject: CGFloat {
        if let number = number {
            switch number {
            case .one:
                return bounds.height * 3 / 8
            case .two:
                return bounds.height * 1 / 6
            case .three:
                return bounds.height * 1 / 16
            }
        }
        return bounds.height * 3 / 8
    }
}

