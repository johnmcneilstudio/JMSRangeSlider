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
    
    case horizontal = 1
    case vertical
    
}

public enum JMSRangeSliderCellsSide: Int {
    
    case top = 1
    case bottom
    case left
    case right
    
}

open class JMSRangeSlider: NSControl {

    // Previous mouse location
    fileprivate var previousLocation: CGPoint = CGPoint()
    
    // Private vars
    fileprivate let trackLayer: RangeSliderTrackLayer = RangeSliderTrackLayer()
    fileprivate let lowerCellLayer: RangeSliderCellLayer = RangeSliderCellLayer()
    fileprivate let upperCellLayer: RangeSliderCellLayer = RangeSliderCellLayer()
    
    // Slider Direction ( Horizontal / Vertical )
    open var direction: JMSRangeSliderDirection = JMSRangeSliderDirection.horizontal {
        didSet {
            // Default values 
            // Left side when vertical position
            // Top side when horizontal position
            if direction == JMSRangeSliderDirection.vertical {
                if cellsSide != JMSRangeSliderCellsSide.left || cellsSide != JMSRangeSliderCellsSide.right {
                    cellsSide = JMSRangeSliderCellsSide.left
                }
            } else {
                if cellsSide != JMSRangeSliderCellsSide.top || cellsSide != JMSRangeSliderCellsSide.bottom {
                    cellsSide = JMSRangeSliderCellsSide.top
                }
            }
            updateLayerFrames()
        }
    }
    
    // Cells side ( Top / Bottom / Left / Right )
    open var cellsSide: JMSRangeSliderCellsSide = JMSRangeSliderCellsSide.top {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Slider minimum value
    open var minValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Slider maximum value
    open var maxValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Slider lower value
    open var lowerValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Slider upper value
    open var upperValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Cell width
    open var cellWidth: CGFloat = 20.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Cell height
    open var cellHeight: CGFloat = 20.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Frame
    open override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Track thickness
    open var trackThickness: CGFloat = 10.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Track tint color
    open var trackTintColor: NSColor = NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    // Track highlight tint color
    open var trackHighlightTintColor: NSColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    // Cell tint color
    open var cellTintColor: NSColor = NSColor.white {
        didSet {
            lowerCellLayer.setNeedsDisplay()
            upperCellLayer.setNeedsDisplay()
        }
    }

    // Corner radius
    open var cornerRadius: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    
    // INIT
    
    public convenience init() {
        
        self.init(frame: CGRect.zero)
        
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = (NSScreen.main()?.backingScaleFactor)!
        layer?.addSublayer(trackLayer)
        
        lowerCellLayer.rangeSlider = self
        lowerCellLayer.cellPosition = CellPosition.lower
        lowerCellLayer.contentsScale = (NSScreen.main()?.backingScaleFactor)!
        layer?.addSublayer(lowerCellLayer)
        
        upperCellLayer.rangeSlider = self
        upperCellLayer.cellPosition = CellPosition.upper
        upperCellLayer.contentsScale = (NSScreen.main()?.backingScaleFactor)!
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
    open override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
    }
    
    // @function        mouseDown
    // Called on mouse down
    //
    open override func mouseDown(with evt: NSEvent) {
        
        let location = evt.locationInWindow
        previousLocation = convert(location, from: nil)
        
        if lowerCellLayer.frame.contains(previousLocation) {
            lowerCellLayer.highlighted = true
        } else if upperCellLayer.frame.contains(previousLocation) {
            upperCellLayer.highlighted = true
        }
        
    }
    
    
    // @function        mouseDragged
    // Called on mouse dragged
    //
    open override func mouseDragged(with evt: NSEvent) {
        
        let location = evt.locationInWindow
        let pointInView = convert(location, from: nil)

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
        NSApp.sendAction(self.action!, to: self.target, from: self)
        
    }
    
    // @function        mouseUp
    // Called on mouse up
    //
    open override func mouseUp(with evt: NSEvent) {
        
        // Cells not highlighted anymore
        lowerCellLayer.highlighted = false
        upperCellLayer.highlighted = false
        
    }
    
    // @function        isVertical
    // Returns wether or not the slider is in vertical direction
    //
    open func isVertical() -> Bool {
        
        return self.direction == JMSRangeSliderDirection.vertical
        
    }
    
    
    
    //
    // PUBLIC
    //
    
    // @function        updateLayerFrames
    // Updates layers frame
    //
    fileprivate func updateLayerFrames() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let lowerCellCenter = CGFloat(positionForValue(lowerValue))
        let upperCellCenter = CGFloat(positionForValue(upperValue))
        
        // Is vertical ?
        if self.isVertical() {
            trackLayer.frame = CGRect(x: self.frame.width - self.trackThickness, y: self.cellHeight, width: self.trackThickness, height: bounds.height - 2 * self.cellHeight)
            lowerCellLayer.frame = CGRect(x: trackLayer.frame.origin.x - cellWidth, y: lowerCellCenter, width: cellWidth, height: cellHeight)
            upperCellLayer.frame = CGRect(x: trackLayer.frame.origin.x - cellWidth, y: upperCellCenter + cellHeight, width: cellWidth, height: cellHeight)
            
            // If Cells on the right side
            if cellsSide == JMSRangeSliderCellsSide.right {
                trackLayer.frame.origin.x = 0.0
                lowerCellLayer.frame.origin.x = trackLayer.frame.width
                upperCellLayer.frame.origin.x = trackLayer.frame.width
            }
            
        // Is Horizontal ?
        } else {
            trackLayer.frame = CGRect(x: self.cellWidth, y: 0, width: bounds.width - 2 * cellWidth, height: self.trackThickness)
            lowerCellLayer.frame = CGRect(x: lowerCellCenter, y: self.trackThickness, width: cellWidth, height: cellHeight)
            upperCellLayer.frame = CGRect(x: upperCellCenter + cellWidth, y: self.trackThickness, width: cellWidth, height: cellHeight)
            
            // If Cells on the bottom side
            if cellsSide == JMSRangeSliderCellsSide.bottom {
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
    internal func positionForValue(_ value: Double) -> Double {
        
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
    internal func boundValue(_ value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        
        return min(max(value, lowerValue), upperValue)
        
    }
    
}
