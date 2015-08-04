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
    
    // Highlighted
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Cell Position
    var cellPosition: CellPosition?
    
    // Range Slider weak var
    weak var rangeSlider: JMSRangeSlider?
    
    // @function        drawInContext
    // Draw in context
    //
    override func drawInContext(ctx: CGContext) {
        if let slider = rangeSlider {
            
            var cellPoints = (begin: NSPoint(x: 0, y: 0), second: NSPoint(x: 0, y: 0), third: NSPoint(x: 0, y: 0), fourth: NSPoint(x: 0, y: 0))
            let cellPath: NSBezierPath = NSBezierPath()
            let sliceCutHeight: CGFloat = 2 * frame.height / 3
            let sliceCutWidth: CGFloat = frame.width / 3
            
            switch slider.cellsSide {
                
            // Slider Horizontal, cells on top
            case .Top:
                cellPoints.begin = NSMakePoint(0, sliceCutHeight)
                cellPoints.second = NSMakePoint(0, frame.height)
                cellPoints.third = NSMakePoint(frame.width, frame.height)
                cellPoints.fourth = NSMakePoint(frame.width, 0)
                
                if cellPosition == CellPosition.Upper {
                    cellPoints.begin.y = 0.0
                    cellPoints.fourth.y = sliceCutHeight
                }
                break
                
            // Slider Horizontal, cells on bottom
            case .Bottom:
                cellPoints.begin = NSMakePoint(0, 0)
                cellPoints.second = NSMakePoint(0, sliceCutHeight)
                cellPoints.third = NSMakePoint(frame.width, frame.height)
                cellPoints.fourth = NSMakePoint(frame.width, 0)
                
                if cellPosition == CellPosition.Upper {
                    cellPoints.second.y = frame.height
                    cellPoints.third.y = sliceCutHeight
                }
                break
            
            // Slider vertical, cells on left
            case .Left:
                cellPoints.begin = NSMakePoint(0, 0)
                cellPoints.second = NSMakePoint(0, frame.height)
                cellPoints.third = NSMakePoint(frame.width, frame.height)
                cellPoints.fourth = NSMakePoint(sliceCutWidth, 0)
                
                if cellPosition == CellPosition.Upper {
                    cellPoints.third.x = sliceCutWidth
                    cellPoints.fourth.x = frame.width
                }
                break
                
            // Slider vertical, cells on right
            case .Right:
                cellPoints.begin = NSMakePoint(sliceCutWidth, 0)
                cellPoints.second = NSMakePoint(0, frame.height)
                cellPoints.third = NSMakePoint(frame.width, frame.height)
                cellPoints.fourth = NSMakePoint(frame.width, 0)
                
                if cellPosition == CellPosition.Upper {
                    cellPoints.begin.x = 0
                    cellPoints.second.x = sliceCutWidth
                }
                break
                
            }
            
            // First point
            cellPath.moveToPoint(cellPoints.begin)
            cellPath.lineToPoint(cellPoints.second)
            cellPath.lineToPoint(cellPoints.third)
            cellPath.lineToPoint(cellPoints.fourth)
            cellPath.lineToPoint(cellPoints.begin)
            
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
