//
//  Grid.swift
//
//  Created by CS193p Instructor.
//  Copyright © 2017 Stanford University. All rights reserved.
//
//  Arranges the space in a rectangle into a grid of cells.
//  All cells will be exactly the same size.
//  If the grid does not fill the provided frame edge-to-edge
//    then it will center the grid of cells in the provided frame.
//  If you want spacing between cells in the grid, simply inset each cell's frame.
//
//  How it lays the cells out is determined by the layout property:
//  Layout can be done by (a) fixing the cell size
//    (Grid will create as many rows and columns as will fit)
//  Or (b) fixing the number of rows and columns
//    (Grid will make the cells as large as possible)
//  Or (c) ensuring a certain aspect ratio (width vs. height) for each cell
//    (Grid will make cellCount cells fit, making the cells as large as possible)
//    (you must set the cellCount var for the aspectRatio layout to know what to do)
//
//  The bounding rectangle of a cell in the grid is obtained by subscript (e.g. grid[11] or grid[1,5]).
//  The dimensions tuple will contain the number of (calculated or specified) rows and columns.
//  Setting aspectRatio, dimensions or cellSize, may change the layout.
//
//  To use, simply employ the initializer to choose a layout strategy and set the frame.
//  After creating a Grid, you can change the frame or layout strategy at any time
//    (all other properties will immediately update).

import UIKit

struct SetGrid {
    
    static var idealAspectRatio: CGFloat = 0.7
    
    private var bounds: CGRect { didSet { calculateGrid() } }
    private var numberOfFrames: Int  { didSet { calculateGrid() } }
    
    private var bestGridDimensions: GridDimensions?
    private var cellFrames: [CGRect] = []
    
    var row: Int {
        if let rows = bestGridDimensions?.rows {
            return rows
        }
        return 0
    }
    
    var col: Int {
        if let rows = bestGridDimensions?.cols {
            return rows
        }
        return 0
    }
    
    init(for bounds: CGRect, withNoOfFrames: Int, forIdeal aspectRatio: CGFloat = SetGrid.idealAspectRatio) {
        self.bounds = bounds
        self.numberOfFrames = withNoOfFrames
        SetGrid.idealAspectRatio = aspectRatio
        calculateGrid()
    }
    
    subscript(index: Int) -> CGRect? {
        return index < cellFrames.count ? cellFrames[index] : nil
    }
    
    private mutating func calculateGridDimensions() {
        for cols in 1...numberOfFrames {
            let rows = numberOfFrames % cols == 0 ? numberOfFrames / cols: numberOfFrames/cols + 1
            
            let calculatedframeDimension = GridDimensions(
                cols: cols,
                rows: rows,
                frameSize: CGSize(width: bounds.width / CGFloat(cols), height: bounds.height / CGFloat(rows))
            )
            
            if let bestFrameDimension = bestGridDimensions, bestFrameDimension > calculatedframeDimension {
                return
            } else {
                self.bestGridDimensions = calculatedframeDimension
            }
        }
        return
    }
    
    private mutating func calculateGrid() {
        var grid = [CGRect]()
        calculateGridDimensions()
        
        guard let bestGridDimensions = bestGridDimensions else {
            grid = []
            return
        }
        
        for row in 0..<bestGridDimensions.rows {
            for col in 0..<bestGridDimensions.cols {
                let origin = CGPoint(x: CGFloat(col) * bestGridDimensions.frameSize.width, y: CGFloat(row) * bestGridDimensions.frameSize.height)
                let rect = CGRect(origin: origin, size: bestGridDimensions.frameSize)
                grid.append(rect)
            }
        }
        self.cellFrames = grid
    }
}

extension SetGrid {
    
    private struct GridDimensions: Comparable {
        static func <(lhs: SetGrid.GridDimensions, rhs: SetGrid.GridDimensions) -> Bool {
            return lhs.isCloserToIdeal(aspectRatio: rhs.aspectRatio)
        }
        
        static func ==(lhs: SetGrid.GridDimensions, rhs: SetGrid.GridDimensions) -> Bool {
            return lhs.cols == rhs.cols && lhs.rows == rhs.rows
        }
        
        var cols: Int
        var rows: Int
        var frameSize: CGSize
        var aspectRatio: CGFloat {
            return frameSize.width/frameSize.height
        }
        
        func isCloserToIdeal(aspectRatio: CGFloat) -> Bool {
            return (SetGrid.idealAspectRatio - aspectRatio).abs < (SetGrid.idealAspectRatio - self.aspectRatio).abs
        }
    }
}


extension CGFloat {
    var abs: CGFloat {
        return self<0 ? -self: self
    }
}

