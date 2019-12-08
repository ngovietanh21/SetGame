//
//  CardView.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var state: State.stateOfSeclection?
    var card: Card?
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
    
    convenience init(frame: CGRect, card: Card) {
        self.init(frame: frame)
        self.card = card
        self.state = State.stateOfSeclection.unselected
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private var boarderColor: UIColor {
        if let state = state {
            switch state {
            case .hinted:
                return #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
            case .selected:
                return #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
            case .unselected:
                return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
        return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
            let boarder = UIBezierPath(rect: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height))
            
            boarder.lineWidth = state == State.stateOfSeclection.unselected ?
                CardView.unselectedBoarderWidth :
                CardView.selectedBoarderWidth
            boarderColor.setStroke()
            boarder.stroke()
            
        } else {
            let back = UIBezierPath(rect: bounds)
            #colorLiteral(red: 0.423529923, green: 0.6870478392, blue: 0.8348321319, alpha: 1).setFill()
            back.fill()
        }
        
    }
    
}

extension CardView {
    static let unselectedBoarderWidth: CGFloat = 3
    static let selectedBoarderWidth: CGFloat = 5
    
    private var heightOfObject: CGFloat {
        return bounds.height / 4
    }
    
    private var marginToObject: CGFloat {
        return bounds.midX - heightOfObject / 2
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

struct State {
    enum stateOfSeclection {
        case selected
        case unselected
        case hinted
    }
}

