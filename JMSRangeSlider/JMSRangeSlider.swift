//
//  JMSRangeSlider.swift
//  JMSRangeSlider
//
//  Created by Matthieu Collé on 23/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa
import QuartzCore

class JMSRangeSlider: NSControl {

    var minValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    var maxValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }

    var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }

    var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var previousLocation: CGPoint = CGPoint()
    
    let trackLayer: RangeSliderTrackLayer = RangeSliderTrackLayer()
    let lowerCellLayer: RangeSliderCellLayer = RangeSliderCellLayer()
    let upperCellLayer: RangeSliderCellLayer = RangeSliderCellLayer()
    
    var cellWidth: CGFloat = 20.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var cellHeight: CGFloat {
        return CGFloat(2 * (bounds.height / 3))
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    var trackTintColor: NSColor = NSColor(white: 0.8, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    var trackHighlightTintColor: NSColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    var cellTintColor: NSColor = NSColor.whiteColor() {
        didSet {
            lowerCellLayer.setNeedsDisplay()
            upperCellLayer.setNeedsDisplay()
        }
    }

    var cornerRadius: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerCellLayer.setNeedsDisplay()
            upperCellLayer.setNeedsDisplay()
        }
    }
    
    
    // INIT
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // OVERRIDE
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = (NSScreen.mainScreen()?.backingScaleFactor)!
        layer?.addSublayer(trackLayer)
        
        lowerCellLayer.rangeSlider = self
        lowerCellLayer.cellPosition = CellPosition.Lower
        lowerCellLayer.contentsScale = (NSScreen.mainScreen()?.backingScaleFactor)!
        lowerCellLayer.cornerRadius = cornerRadius
        layer?.addSublayer(lowerCellLayer)
        
        upperCellLayer.rangeSlider = self
        upperCellLayer.cellPosition = CellPosition.Upper
        upperCellLayer.contentsScale = (NSScreen.mainScreen()?.backingScaleFactor)!
        upperCellLayer.cornerRadius = cornerRadius
        layer?.addSublayer(upperCellLayer)
        
        updateLayerFrames()
    }
    
    
    override func mouseDown(evt: NSEvent) {
        let location = evt.locationInWindow
        previousLocation = convertPoint(location, fromView: nil)
        
        if lowerCellLayer.frame.contains(previousLocation) {
            lowerCellLayer.highlighted = true
        } else if upperCellLayer.frame.contains(previousLocation) {
            upperCellLayer.highlighted = true
        }
    }
    
    override func mouseDragged(evt: NSEvent) {
        
        let location = evt.locationInWindow
        let pointInView = convertPoint(location, fromView: nil)

        // Get delta
        let deltaLocation = Double(pointInView.x - previousLocation.x)
        let deltaValue = (maxValue - minValue) * deltaLocation / Double(bounds.width - cellWidth)
        
        previousLocation = pointInView
        
        // Update values
        if lowerCellLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minValue, upperValue: upperValue)
        } else if upperCellLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maxValue)
        }
        
        updateLayerFrames()
        
        // Notify
        NSApp.sendAction(self.action, to: self.target, from: self)
        
    }
    
    override func mouseUp(evt: NSEvent) {
        lowerCellLayer.highlighted = false
        upperCellLayer.highlighted = false
    }
    
    
    // PUBLIC
    
    // @function    updateLayerFrames
    //
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = CGRectMake(cellWidth, 0, bounds.width - 2 * cellWidth, bounds.height/3)
        trackLayer.setNeedsDisplay()
        
        let lowerCellCenter = CGFloat(positionForValue(lowerValue))
        
        lowerCellLayer.frame = CGRect(x: lowerCellCenter, y: trackLayer.frame.height, width: cellWidth, height: cellHeight)
        lowerCellLayer.setNeedsDisplay()
        
        let upperCellCenter = CGFloat(positionForValue(upperValue))
        upperCellLayer.frame = CGRect(x: upperCellCenter + cellWidth, y: trackLayer.frame.height, width: cellWidth, height: cellHeight)
        upperCellLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    
    // INTERNAL
    
    // @function    positionForValue
    //
    internal func positionForValue(value: Double) -> Double {
        return Double(bounds.width - 2 * cellWidth) * (value - minValue) / (maxValue - minValue)
    }
    
    
    // @function    boundValue
    //
    internal func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
}
