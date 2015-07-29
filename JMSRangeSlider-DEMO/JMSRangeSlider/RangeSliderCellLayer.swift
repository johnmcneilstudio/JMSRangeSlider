//
//  RangeSliderCellLayer.swift
//  JMSRangeSlider
//
//  Created by Matthieu Collé on 24/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa

enum CellPosition: Int {
    
    case Lower = 1
    case Upper
    
}

class RangeSliderCellLayer: CALayer {
    
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var cellPosition: CellPosition?
    
    weak var rangeSlider: JMSRangeSlider?
    
    override func drawInContext(ctx: CGContext) {
        if let slider = rangeSlider {
            let cellPath: NSBezierPath = NSBezierPath()
            var beginPoint: NSPoint = NSMakePoint(0, frame.height / 2)
            var cuttingPoint: NSPoint = NSMakePoint(frame.width, 0)
            
            if cellPosition == CellPosition.Upper {
                beginPoint.y = 0.0
                cuttingPoint.y = frame.height / 2
            }
            
            // Begin Point
            cellPath.moveToPoint(beginPoint)
            
            cellPath.lineToPoint(NSMakePoint(0, frame.height))
            cellPath.lineToPoint(NSMakePoint(frame.width, frame.height))
            
            // Cutting Point
            cellPath.lineToPoint(cuttingPoint)
            cellPath.lineToPoint(beginPoint)
            
            // Shadow
            let shadowColor = NSColor.grayColor()
            CGContextSetShadowWithColor(ctx, CGSize(width: 0.0, height: 1.0), 1.0, shadowColor.CGColor)
            CGContextSetFillColorWithColor(ctx, slider.cellTintColor.CGColor)
            CGContextAddPath(ctx, cellPath.CGPath)
            CGContextFillPath(ctx)
            
            // Outline
            CGContextSetStrokeColorWithColor(ctx, shadowColor.CGColor)
            CGContextSetLineWidth(ctx, 0.5)
            CGContextAddPath(ctx, cellPath.CGPath)
            CGContextStrokePath(ctx)
            
            if highlighted {
                CGContextSetFillColorWithColor(ctx, NSColor(white: 0.0, alpha: 0.1).CGColor)
                CGContextAddPath(ctx, cellPath.CGPath)
                CGContextFillPath(ctx)
            }
        }
    }
    
}
