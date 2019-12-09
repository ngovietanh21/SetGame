//
//  ObjectView.swift
//  SetGame
//
//  Created by Viet Anh on 12/8/19.
//  Copyright © 2019 VietAnh. All rights reserved.
//

import UIKit

class ObjectView: UIView {
    
    private var shape: Shapes?
    private var color: Colors?
    private var fill: Fills?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, shape: Shapes, color: Colors, fill: Fills) {
        self.init(frame: frame)
        self.shape = shape
        self.color = color
        self.fill = fill
    }
    
    private var path: UIBezierPath {
        if let shape = shape {
            switch shape {
            case .circle:
                return UIBezierPath(arcCenter:
                    CGPoint(x: bounds.midX, y: bounds.midY),
                                    radius: bounds.height / 2,
                                    startAngle: 0,
                                    endAngle: CGFloat.pi * 2,
                                    clockwise: true)
                
            case .square:
                return UIBezierPath(rect:
                    CGRect(x: bounds.origin.x,
                           y: bounds.origin.y,
                           width: bounds.width,
                           height: bounds.height))
                
            case .triangle:
                let path = UIBezierPath()
                path.move(to: CGPoint(x: bounds.width / 2, y: bounds.origin.y))
                path.addLine(to: CGPoint(x: bounds.origin.x, y: bounds.height))
                path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
                path.close()
                return path
            }
        }
        return UIBezierPath()
    }
    
    override func draw(_ rect: CGRect) {
        let shape = path
        path.addClip()
        
        if let fill = fill {
            switch fill {
            case .empty:
                objectColor.setStroke()
                shape.lineWidth = boarderOfObject
                shape.stroke()
                
            case .solid:
                objectColor.setFill()
                shape.stroke()
                shape.fill()
                
            case .stripe:
                objectColor.setStroke()
                shape.lineWidth = boarderOfObject
                shape.stroke()
                for x in stride(from: 0, to: bounds.width, by: bounds.width / 5) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: x))
                    path.lineWidth = lineWidthOfStripe
                    path.stroke()
                }
                for y in stride(from: 0, to: bounds.width, by: bounds.width / 5) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: y, y: bounds.height))
                    path.addLine(to: CGPoint(x: bounds.width, y: y))
                    path.lineWidth = lineWidthOfStripe
                    path.stroke()
                }
            }
            
        }
        
    }
    
}

extension ObjectView {
    private var boarderOfObject: CGFloat {
        return 3
    }
    
    private var lineWidthOfStripe: CGFloat {
        return 1
    }
    
    private var objectColor: UIColor {
        if let color = color {
            switch color {
            case .red: return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            case .green: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .blue: return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            }
        }
        
        return UIColor()
    }
    
}
