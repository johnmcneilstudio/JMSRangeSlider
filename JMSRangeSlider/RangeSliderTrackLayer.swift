//
//  RangeSliderTrackLayer.swift
//  JMSRangeSlider
//
//  Created by Matthieu Collé on 24/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa


extension NSBezierPath {
    
    internal var CGPath: CGPath {
        
        get {
            return self.transformToCGPath()
        }
    }
    
    /// Transforms the NSBezierPath into a CGPathRef
    ///
    /// :returns: The transformed NSBezierPath
    fileprivate func transformToCGPath() -> CGPath {
        
        // Create path
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        let numElements = self.elementCount
        
        if numElements > 0 {
            
            var didClosePath = true
            
            for index in 0..<numElements {
                
                let pathType = self.element(at: index, associatedPoints: points)
                
                switch pathType {
                    
                case .moveToBezierPathElement:
                    path.move(to: points[0])
                case .lineToBezierPathElement:
                    path.addLine(to: points[0])
                    didClosePath = false
                case .curveToBezierPathElement:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                    didClosePath = false
                case .closePathBezierPathElement:
                    path.closeSubpath()
                    didClosePath = true
                }
            }
            
            if !didClosePath { path.closeSubpath() }
        }
        
        points.deallocate(capacity: 3)
        return path
    }
}


class RangeSliderTrackLayer: CALayer {

    // Range Slider weak var
    weak var rangeSlider: JMSRangeSlider?
    
    // @function        drawInContext
    // Draw in context
    //
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            // Clip
            let path = NSBezierPath(roundedRect: bounds, xRadius: slider.trackCornerRadius, yRadius: slider.trackCornerRadius)
            
            ctx.addPath(path.CGPath)
            
            // Fill the track
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.fillPath()
            
            // Fill the highlighted range
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue) - (Double(slider.cellWidth)*0.5) + 1.0)
            let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue) + (Double(slider.cellWidth)*0.5) + 1.0)
            
            // If slider is horizontal
            var rect: CGRect = CGRect.zero
            if slider.isVertical {
                let y = slider.extendTrackToFrame ? lowerValuePosition + slider.cellHeight - 2.0 : lowerValuePosition
                rect = CGRect(x: 0.0, y: y, width: bounds.width, height: upperValuePosition - lowerValuePosition)
            } else {
                let x = slider.extendTrackToFrame ? lowerValuePosition + slider.cellWidth - 2.0 : lowerValuePosition
                rect = CGRect(x: x, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
            }
            
            let highlightCornerRadius = slider.cellsSide == .centerHoriz || slider.cellsSide == .centerVert ? 0.0 : cornerRadius
            let highlightPath = NSBezierPath(roundedRect: rect, xRadius: highlightCornerRadius, yRadius: highlightCornerRadius)
            ctx.addPath(highlightPath.CGPath)
            ctx.fillPath()
        }
    }
    
}
