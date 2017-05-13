//
//  RangeSliderCellLayer.swift
//  JMSRangeSlider
//
//  Created by Matthieu Collé on 24/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa

enum CellPosition: Int {
    
    case lower = 1
    case upper
    
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
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            
            if cellPosition == .lower, let drawingFunction = slider.lowerCellDrawingFunction {
                drawingFunction(self.bounds, ctx)
            } else if cellPosition == .upper, let drawingFunction = slider.upperCellDrawingFunction {
                drawingFunction(self.bounds, ctx)
            } else {
                var cellPoints = (begin: NSPoint(x: 0, y: 0), second: NSPoint(x: 0, y: 0), third: NSPoint(x: 0, y: 0), fourth: NSPoint(x: 0, y: 0))
                let cellPath: NSBezierPath = NSBezierPath()
                let sliceCutHeight: CGFloat = 2 * frame.height / 3
                let sliceCutWidth: CGFloat = frame.width / 3
                
                switch slider.cellsSide {
                    
                // Slider Horizontal, cells on top
                case .top:
                    cellPoints.begin = NSMakePoint(0, sliceCutHeight)
                    cellPoints.second = NSMakePoint(0, frame.height)
                    cellPoints.third = NSMakePoint(frame.width, frame.height)
                    cellPoints.fourth = NSMakePoint(frame.width, 0)
                    
                    if cellPosition == CellPosition.upper {
                        cellPoints.begin.y = 0.0
                        cellPoints.fourth.y = sliceCutHeight
                    }
                    break
                    
                // Slider Horizontal, cells on bottom
                case .bottom:
                    cellPoints.begin = NSMakePoint(0, 0)
                    cellPoints.second = NSMakePoint(0, sliceCutHeight)
                    cellPoints.third = NSMakePoint(frame.width, frame.height)
                    cellPoints.fourth = NSMakePoint(frame.width, 0)
                    
                    if cellPosition == CellPosition.upper {
                        cellPoints.second.y = frame.height
                        cellPoints.third.y = sliceCutHeight
                    }
                    break
                    
                // Slider Horizontal, cells in center
                case .centerHoriz:
                    cellPoints.begin = NSMakePoint(0, 0)
                    cellPoints.second = NSMakePoint(0, frame.height)
                    cellPoints.third = NSMakePoint(frame.width, frame.height)
                    cellPoints.fourth = NSMakePoint(frame.width, 0)
                    break
                    
                // Slider vertical, cells on left
                case .left:
                    cellPoints.begin = NSMakePoint(0, 0)
                    cellPoints.second = NSMakePoint(0, frame.height)
                    cellPoints.third = NSMakePoint(frame.width, frame.height)
                    cellPoints.fourth = NSMakePoint(sliceCutWidth, 0)
                    
                    if cellPosition == CellPosition.upper {
                        cellPoints.third.x = sliceCutWidth
                        cellPoints.fourth.x = frame.width
                    }
                    break
                    
                // Slider vertical, cells on right
                case .right:
                    cellPoints.begin = NSMakePoint(sliceCutWidth, 0)
                    cellPoints.second = NSMakePoint(0, frame.height)
                    cellPoints.third = NSMakePoint(frame.width, frame.height)
                    cellPoints.fourth = NSMakePoint(frame.width, 0)
                    
                    if cellPosition == CellPosition.upper {
                        cellPoints.begin.x = 0
                        cellPoints.second.x = sliceCutWidth
                    }
                    break
                    
                // Slider vertical, cells in center
                case .centerVert:
                    cellPoints.begin = NSMakePoint(0, 0)
                    cellPoints.second = NSMakePoint(0, frame.height)
                    cellPoints.third = NSMakePoint(frame.width, frame.height)
                    cellPoints.fourth = NSMakePoint(frame.width, 0)
                    break
                    
                }
                
                // First point
                cellPath.move(to: cellPoints.begin)
                cellPath.line(to: cellPoints.second)
                cellPath.line(to: cellPoints.third)
                cellPath.line(to: cellPoints.fourth)
                cellPath.line(to: cellPoints.begin)
                
                // Shadow
                let shadowColor = NSColor.gray
                ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 1.0, color: shadowColor.cgColor)
                ctx.setFillColor(slider.cellTintColor.cgColor)
                ctx.addPath(cellPath.CGPath)
                ctx.fillPath()
                
                // Outline
                ctx.setStrokeColor(shadowColor.cgColor)
                ctx.setLineWidth(0.5)
                ctx.addPath(cellPath.CGPath)
                ctx.strokePath()
                
                if highlighted {
                    ctx.setFillColor(NSColor(white: 0.0, alpha: 0.1).cgColor)
                    ctx.addPath(cellPath.CGPath)
                    ctx.fillPath()
                }
            }
        }
    }
    
}
