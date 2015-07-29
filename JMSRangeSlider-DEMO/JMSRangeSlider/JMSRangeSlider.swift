//
//  JMSRangeSlider.swift
//  JMSRangeSlider
//
//  Created by Matthieu Collé on 23/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa
import QuartzCore

public class JMSRangeSlider: NSControl {

    private var previousLocation: CGPoint = CGPoint()
    
    private let trackLayer: RangeSliderTrackLayer = RangeSliderTrackLayer()
    private let lowerCellLayer: RangeSliderCellLayer = RangeSliderCellLayer()
    private let upperCellLayer: RangeSliderCellLayer = RangeSliderCellLayer()
    
    public var minValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    public var maxValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var cellWidth: CGFloat = 20.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var cellHeight: CGFloat {
        return CGFloat(2 * (bounds.height / 3))
    }
    
    public override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var trackTintColor: NSColor = NSColor(white: 0.8, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    public var trackHighlightTintColor: NSColor = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    public var cellTintColor: NSColor = NSColor.whiteColor() {
        didSet {
            lowerCellLayer.setNeedsDisplay()
            upperCellLayer.setNeedsDisplay()
        }
    }

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
    
    
    // OVERRIDE
    
    public override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    public override func mouseDown(evt: NSEvent) {
        let location = evt.locationInWindow
        previousLocation = convertPoint(location, fromView: nil)
        
        if lowerCellLayer.frame.contains(previousLocation) {
            lowerCellLayer.highlighted = true
        } else if upperCellLayer.frame.contains(previousLocation) {
            upperCellLayer.highlighted = true
        }
    }
    
    public override func mouseDragged(evt: NSEvent) {
        
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
    
    public override func mouseUp(evt: NSEvent) {
        lowerCellLayer.highlighted = false
        upperCellLayer.highlighted = false
    }
    
    
    // PUBLIC
    
    // @function    updateLayerFrames
    //
    private func updateLayerFrames() {
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
