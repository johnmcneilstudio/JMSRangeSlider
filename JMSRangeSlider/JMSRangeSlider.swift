//
//  JMSRangeSlider.swift
//  JMSRangeSlider
//
//  Created by Matthieu Collé on 23/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa
import QuartzCore

public enum JMSRangeSliderDirection: Int {
    
    case Horizontal = 1
    case Vertical
    
}

public enum JMSRangeSliderCellsSide: Int {
    
    case Top = 1
    case Bottom
    case Left
    case Right
    
}

public class JMSRangeSlider: NSControl {

    // Previous mouse location
    private var previousLocation: CGPoint = CGPoint()
    
    // Private vars
    private let trackLayer: RangeSliderTrackLayer = RangeSliderTrackLayer()
    private let lowerCellLayer: RangeSliderCellLayer = RangeSliderCellLayer()
    private let upperCellLayer: RangeSliderCellLayer = RangeSliderCellLayer()
    
    // Slider Direction ( Horizontal / Vertical )
    public var direction: JMSRangeSliderDirection = JMSRangeSliderDirection.Horizontal {
        didSet {
            // Default values 
            // Left side when vertical position
            // Top side when horizontal position
            if direction == JMSRangeSliderDirection.Vertical {
                if cellsSide != JMSRangeSliderCellsSide.Left || cellsSide != JMSRangeSliderCellsSide.Right {
                    cellsSide = JMSRangeSliderCellsSide.Left
                }
            } else {
                if cellsSide != JMSRangeSliderCellsSide.Top || cellsSide != JMSRangeSliderCellsSide.Bottom {
                    cellsSide = JMSRangeSliderCellsSide.Top
                }
            }
            updateLayerFrames()
        }
    }
    
    // Cells side ( Top / Bottom / Left / Right )
    public var cellsSide: JMSRangeSliderCellsSide = JMSRangeSliderCellsSide.Top {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Slider minimum value
    public var minValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Slider maximum value
    public var maxValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Slider lower value
    public var lowerValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Slider upper value
    public var upperValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Cell width
    public var cellWidth: CGFloat = 20.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Cell height
    public var cellHeight: CGFloat = 20.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Frame
    public override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Track thickness
    public var trackThickness: CGFloat = 10.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Track tint color
    public var trackTintColor: NSColor = NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    // Track highlight tint color
    public var trackHighlightTintColor: NSColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    // Cell tint color
    public var cellTintColor: NSColor = NSColor.whiteColor() {
        didSet {
            lowerCellLayer.setNeedsDisplay()
            upperCellLayer.setNeedsDisplay()
        }
    }

    // Corner radius
    public var cornerRadius: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    
    // INIT
    
    public convenience init() {
        
        self.init(frame: CGRectZero)
        
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = (NSScreen.mainScreen()?.backingScaleFactor)!
        layer?.addSublayer(trackLayer)
        
        lowerCellLayer.rangeSlider = self
        lowerCellLayer.cellPosition = CellPosition.Lower
        lowerCellLayer.contentsScale = (NSScreen.mainScreen()?.backingScaleFactor)!
        layer?.addSublayer(lowerCellLayer)
        
        upperCellLayer.rangeSlider = self
        upperCellLayer.cellPosition = CellPosition.Upper
        upperCellLayer.contentsScale = (NSScreen.mainScreen()?.backingScaleFactor)!
        layer?.addSublayer(upperCellLayer)
        
        updateLayerFrames()
        
    }
    
    public required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    
    //
    // OVERRIDE
    //
    
    // @function        drawRect
    // Draw rect
    //
    public override func drawRect(dirtyRect: NSRect) {
        
        super.drawRect(dirtyRect)
        
    }
    
    // @function        mouseDown
    // Called on mouse down
    //
    public override func mouseDown(evt: NSEvent) {
        
        let location = evt.locationInWindow
        previousLocation = convertPoint(location, fromView: nil)
        
        if lowerCellLayer.frame.contains(previousLocation) {
            lowerCellLayer.highlighted = true
        } else if upperCellLayer.frame.contains(previousLocation) {
            upperCellLayer.highlighted = true
        }
        
    }
    
    
    // @function        mouseDragged
    // Called on mouse dragged
    //
    public override func mouseDragged(evt: NSEvent) {
        
        let location = evt.locationInWindow
        let pointInView = convertPoint(location, fromView: nil)

        // Get delta
        let deltaLocation = self.isVertical() ? Double(pointInView.y - previousLocation.y) : Double(pointInView.x - previousLocation.x)
        
        let deltaValue = (maxValue - minValue) * deltaLocation / (self.isVertical() ? Double(bounds.height - cellHeight) : Double(bounds.width - cellWidth))
        
        previousLocation = pointInView
        
        // Update values
        if lowerCellLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minValue, upperValue: upperValue)
        } else if upperCellLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maxValue)
        }
        
        // Update Layer
        updateLayerFrames()
        
        // Notify App
        NSApp.sendAction(self.action, to: self.target, from: self)
        
    }
    
    // @function        mouseUp
    // Called on mouse up
    //
    public override func mouseUp(evt: NSEvent) {
        
        // Cells not highlighted anymore
        lowerCellLayer.highlighted = false
        upperCellLayer.highlighted = false
        
    }
    
    // @function        isVertical
    // Returns wether or not the slider is in vertical direction
    //
    public func isVertical() -> Bool {
        
        return self.direction == JMSRangeSliderDirection.Vertical
        
    }
    
    
    
    //
    // PUBLIC
    //
    
    // @function        updateLayerFrames
    // Updates layers frame
    //
    private func updateLayerFrames() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let lowerCellCenter = CGFloat(positionForValue(lowerValue))
        let upperCellCenter = CGFloat(positionForValue(upperValue))
        
        // Is vertical ?
        if self.isVertical() {
            trackLayer.frame = CGRectMake(self.frame.width - self.trackThickness, self.cellHeight, self.trackThickness, bounds.height - 2 * self.cellHeight)
            lowerCellLayer.frame = CGRect(x: trackLayer.frame.origin.x - cellWidth, y: lowerCellCenter, width: cellWidth, height: cellHeight)
            upperCellLayer.frame = CGRect(x: trackLayer.frame.origin.x - cellWidth, y: upperCellCenter + cellHeight, width: cellWidth, height: cellHeight)
            
            // If Cells on the right side
            if cellsSide == JMSRangeSliderCellsSide.Right {
                trackLayer.frame.origin.x = 0.0
                lowerCellLayer.frame.origin.x = trackLayer.frame.width
                upperCellLayer.frame.origin.x = trackLayer.frame.width
            }
            
        // Is Horizontal ?
        } else {
            trackLayer.frame = CGRectMake(self.cellWidth, 0, bounds.width - 2 * cellWidth, self.trackThickness)
            lowerCellLayer.frame = CGRect(x: lowerCellCenter, y: self.trackThickness, width: cellWidth, height: cellHeight)
            upperCellLayer.frame = CGRect(x: upperCellCenter + cellWidth, y: self.trackThickness, width: cellWidth, height: cellHeight)
            
            // If Cells on the bottom side
            if cellsSide == JMSRangeSliderCellsSide.Bottom {
                trackLayer.frame.origin.y = self.frame.height - self.trackThickness
                lowerCellLayer.frame.origin.y = trackLayer.frame.origin.y - cellHeight
                upperCellLayer.frame.origin.y = trackLayer.frame.origin.y - cellHeight
            }
        }
        
        // Force display of elements
        trackLayer.setNeedsDisplay()
        lowerCellLayer.setNeedsDisplay()
        upperCellLayer.setNeedsDisplay()
        
        CATransaction.commit()
        
    }
    
    
    //
    // INTERNAL
    //
    
    // @function        positionForValue
    // Get frame position for slider value
    //
    internal func positionForValue(value: Double) -> Double {
        
        // If vertical slider
        if self.isVertical() {
            return Double(bounds.height - 2 * cellHeight) * (value - minValue) / (maxValue - minValue)
        // If horizontal slider
        } else {
            return Double(bounds.width - 2 * cellWidth) * (value - minValue) / (maxValue - minValue)
        }
        
    }
    
    
    // @function        boundValue
    // Bounds value
    //
    internal func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        
        return min(max(value, lowerValue), upperValue)
        
    }
    
}
