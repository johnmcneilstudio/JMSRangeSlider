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
    case centerVert
    case centerHoriz
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
    
    // Returns wether or not the slider is in vertical direction
    open var isVertical: Bool {
        return self.direction == JMSRangeSliderDirection.vertical
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
    
    // Extends the track to the ends of the frame
    open var extendTrackToFrame: Bool = false {
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

    // Track corner radius
    open var trackCornerRadius: CGFloat = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Custom lower cell drawing
    open var lowerCellDrawingFunction: ((_ frame: NSRect, _ context: CGContext) -> (Void))? {
        didSet {
            lowerCellLayer.setNeedsDisplay()
        }
    }
    
    // Custom upper cell drawing
    open var upperCellDrawingFunction: ((_ frame: NSRect, _ context: CGContext) -> (Void))? {
        didSet {
            upperCellLayer.setNeedsDisplay()
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
    // USER INTERACTION
    //
    
    open override func touchesBegan(with event: NSEvent) {
        if #available(OSX 10.12.1, *) {
            if let touch = event.touches(matching: .began, in: self).first {
                interactionBegan(location: touch.location(in: self))
            }
        }
    }
    
    open override func mouseDown(with evt: NSEvent) {
        let location = evt.locationInWindow
        interactionBegan(location: convert(location, from: nil))
    }
    
    open func interactionBegan(location: NSPoint) {
        previousLocation = location
        
        if lowerCellLayer.frame.contains(previousLocation) {
            lowerCellLayer.highlighted = true
        } else if upperCellLayer.frame.contains(previousLocation) {
            upperCellLayer.highlighted = true
        }
    }
    
    open override func touchesMoved(with event: NSEvent) {
        if #available(OSX 10.12.1, *) {
            if let touch = event.touches(matching: .moved, in: self).first {
                interactionMoved(location: touch.location(in: self))
            }
        }
    }
    
    open override func mouseDragged(with evt: NSEvent) {
        let location = evt.locationInWindow
        let pointInView = convert(location, from: nil)
        interactionMoved(location: pointInView)
    }
    
    open func interactionMoved(location: NSPoint) {
        // Get delta
        let deltaLocation = isVertical ? Double(location.y - previousLocation.y) : Double(location.x - previousLocation.x)
        
        let deltaValue = (maxValue - minValue) * deltaLocation / (isVertical ? Double(bounds.height - cellHeight) : Double(bounds.width - cellWidth))
        
        previousLocation = location
        
        // Update values
        var newLowerValue = lowerValue
        var newUpperValue = upperValue
        if lowerCellLayer.highlighted {
            newLowerValue += deltaValue
            newLowerValue = boundValue(newLowerValue, toLowerValue: minValue, upperValue: upperValue)
        } else if upperCellLayer.highlighted {
            newUpperValue += deltaValue
            newUpperValue = boundValue(newUpperValue, toLowerValue: lowerValue, upperValue: maxValue)
        }
        
        if newLowerValue != lowerValue {
            lowerValue = newLowerValue
        } else if newUpperValue != upperValue {
            upperValue = newUpperValue
        }
        
        if newLowerValue != lowerValue || newUpperValue != upperValue {
            // Notify App
            NSApp.sendAction(self.action!, to: self.target, from: self)
        }
    }
    
    open override func touchesEnded(with event: NSEvent) {
        if #available(OSX 10.12.1, *) {
            interactionEnded()
        }
    }
    
    open override func touchesCancelled(with event: NSEvent) {
        if #available(OSX 10.12.1, *) {
            interactionEnded()
        }
    }
    
    open override func mouseUp(with evt: NSEvent) {
        interactionEnded()
    }
    
    open func interactionEnded() {
        // Cells not highlighted anymore
        lowerCellLayer.highlighted = false
        upperCellLayer.highlighted = false
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
        if isVertical {
            let y = extendTrackToFrame ? 2.0 : cellHeight
            let height = extendTrackToFrame ? bounds.height - 4.0 : bounds.height - (2.0 * self.cellHeight)
            trackLayer.frame = CGRect(x: self.frame.width - trackThickness, y: y, width: trackThickness, height: height)
            lowerCellLayer.frame = CGRect(x: trackLayer.frame.origin.x - cellWidth, y: lowerCellCenter, width: cellWidth, height: cellHeight)
            upperCellLayer.frame = CGRect(x: trackLayer.frame.origin.x - cellWidth, y: upperCellCenter + cellHeight, width: cellWidth, height: cellHeight)
            
            // If Cells on the right side
            if cellsSide == JMSRangeSliderCellsSide.right {
                trackLayer.frame.origin.x = 0.0
                lowerCellLayer.frame.origin.x = trackLayer.frame.width
                upperCellLayer.frame.origin.x = trackLayer.frame.width
            // If Cells in the center
            } else if cellsSide == JMSRangeSliderCellsSide.centerVert {
                trackLayer.frame.origin.x = (self.frame.width / 2.0) - (trackThickness / 2.0)
                lowerCellLayer.frame.origin.x = trackThickness / 2.0
                upperCellLayer.frame.origin.x = trackThickness / 2.0
            }
        
        // Is Horizontal ?
        } else {
            let x = extendTrackToFrame ? 2.0 : cellWidth
            let width = extendTrackToFrame ? bounds.width - 4.0 : bounds.width - (2.0 * cellWidth)
            trackLayer.frame = CGRect(x: x, y: 0, width: width, height: trackThickness)
            lowerCellLayer.frame = CGRect(x: lowerCellCenter, y: trackThickness, width: cellWidth, height: cellHeight)
            upperCellLayer.frame = CGRect(x: upperCellCenter + cellWidth, y: trackThickness, width: cellWidth, height: cellHeight)
            
            // If Cells on the bottom side
            if cellsSide == JMSRangeSliderCellsSide.bottom {
                trackLayer.frame.origin.y = self.frame.height - trackThickness
                lowerCellLayer.frame.origin.y = trackLayer.frame.origin.y - cellHeight
                upperCellLayer.frame.origin.y = trackLayer.frame.origin.y - cellHeight
            
            // If Cells in the center
            } else if cellsSide == JMSRangeSliderCellsSide.centerHoriz {
                trackLayer.frame.origin.y = (self.frame.height / 2.0) - (trackThickness / 2.0)
                lowerCellLayer.frame.origin.y = trackThickness / 2.0
                upperCellLayer.frame.origin.y = trackThickness / 2.0
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
        if isVertical {
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


//
// NSTouchBar Style
//

@available(OSX 10.12.1, *)
extension JMSRangeSlider {
    
    // Creates a touch bar item that matches the style of the stock NSSliderTouchBarItem
    public static func touchBarItem(identifier: NSTouchBarItemIdentifier, width: CGFloat = 260.0, target: AnyObject, action: Selector, minValue: Double = 0.0, maxValue: Double = 1.0, lowerValue: Double = 0.0, upperValue: Double = 1.0) -> NSCustomTouchBarItem {
        
        let rangeSlider = JMSRangeSlider()
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        rangeSlider.cellWidth = 32.5
        rangeSlider.cellHeight = 32.5
        rangeSlider.trackThickness = 4.0
        
        rangeSlider.lowerCellDrawingFunction = drawScrubber
        rangeSlider.upperCellDrawingFunction = drawScrubber
        rangeSlider.trackTintColor = NSColor(deviceWhite: 115.0 / 255.0, alpha: 1.0)
        rangeSlider.trackHighlightTintColor = NSColor(deviceRed: 0.0, green: 130.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        rangeSlider.cellsSide = JMSRangeSliderCellsSide.centerHoriz
        rangeSlider.trackCornerRadius = 2.0
        rangeSlider.extendTrackToFrame = true
        
        rangeSlider.minValue = minValue
        rangeSlider.maxValue = maxValue
        rangeSlider.lowerValue = lowerValue
        rangeSlider.upperValue = upperValue
        
        rangeSlider.target = target
        rangeSlider.action = action
        
        let view = TouchBarBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==\(width))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==30.0)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        
        view.addSubview(rangeSlider)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[rangeSlider(==\(width - 10.0))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["rangeSlider": rangeSlider]));
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rangeSlider(==32.5)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["rangeSlider": rangeSlider]));
        view.addConstraint(NSLayoutConstraint(item: rangeSlider, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0));
        view.addConstraint(NSLayoutConstraint(item: rangeSlider, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0));
        
        let item = NSCustomTouchBarItem(identifier: identifier)
        item.view = view
        return item
    }
    
    fileprivate static func drawScrubber(frame: NSRect, context: CGContext) {
        //// Resize to Target Frame
        context.saveGState()
        
        //// scrubberShadow Drawing
        context.saveGState()
        context.setAlpha(0.2)
        
        let scrubberShadowPath = NSBezierPath(roundedRect: NSRect(x: 0, y: -0.5, width: frame.size.width, height: frame.size.height), xRadius: 7, yRadius: 7)
        context.addPath(scrubberShadowPath.CGPath)
        context.setFillColor(NSColor.black.cgColor)
        context.fillPath()
        
        context.restoreGState()
        
        //// scrubberShape Drawing
        let scrubberShapePath = NSBezierPath(roundedRect: NSRect(x: 1, y: -0.5, width: frame.size.width - 2.0, height: frame.size.height - 2.0), xRadius: 6, yRadius: 6)
        context.addPath(scrubberShapePath.CGPath)
        context.setFillColor(NSColor.white.cgColor)
        context.fillPath()
        
        context.restoreGState()
    }
    
    // Using an NSBezierPath for the background because CALayer cornerRadius draws slightly differently
    // and it doesn't exactly match the stock control
    fileprivate class TouchBarBackgroundView: NSView {
        fileprivate override func draw(_ dirtyRect: NSRect) {
            let backgroundColor = NSColor(deviceWhite: 54.0 / 255.0, alpha: 1.0)
            let path = NSBezierPath(roundedRect: self.bounds, xRadius: 6, yRadius: 6)
            backgroundColor.setFill()
            path.fill()
        }
    }
}

