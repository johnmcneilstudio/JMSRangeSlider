//
//  RangeSliderCellLayer.swift
//  JMSRangeSlider
//
//  Created by Matthieu Collé on 24/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa

class RangeSliderCellLayer: CALayer {
    
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var rangeSlider: JMSRangeSlider?
    
    override func drawInContext(ctx: CGContext) {
        if let slider = rangeSlider {
            let cellFrame = bounds.rectByInsetting(dx: 2.0, dy: 2.0)
            let cornerRadius = cellFrame.height * slider.curvaceousness / 2.0
            let cellPath = NSBezierPath(roundedRect: cellFrame, xRadius: cornerRadius, yRadius: cornerRadius)
            
            // Fill - with a subtle shadow
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
