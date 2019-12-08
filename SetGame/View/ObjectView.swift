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
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    private var path: UIBezierPath {
        if let shape = shape {
            switch shape {
            case .circle:
                return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.height / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            case .square:
                return UIBezierPath(rect: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height))
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
        
        var objectColor: UIColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        if let color = color {
            switch color {
            case .green:
                objectColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .blue:
                objectColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
            case .red:
                objectColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            }
        }
        
        if let fill = fill {
            switch fill {
            case .empty:
                objectColor.setStroke()
                shape.lineWidth = CardView.unselectedBoarderWidth
                shape.stroke()
            case .solid:
                objectColor.setFill()
                shape.fill()
            case .stripe:
                objectColor.setStroke()
                for x in stride(from: 0, to: bounds.width, by: bounds.width / 10) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: x))
                    path.stroke()
                }
                for y in stride(from: 0, to: bounds.width, by: bounds.width / 10) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: y, y: bounds.height))
                    path.addLine(to: CGPoint(x: bounds.width, y: y))
                    path.stroke()
                }
            }
        }
    }
    
    
}
