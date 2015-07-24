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

    var minValue: Double = 0.0
    var maxValue: Double = 1.0
    var lowerValue: Double = 0.2
    var upperValue: Double = 0.8
    
    let trackLayer: CALayer = CALayer()
    let lowerCellLayer: CALayer = CALayer()
    let upperCellLayer: CALayer = CALayer()
    
    var cellWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    
    // INIT
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        trackLayer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.753, 0.753, 0.753, 1.0])
        layer?.addSublayer(trackLayer)
        
        lowerCellLayer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.4, 0.698, 1.0, 1.0])
        lowerCellLayer.cornerRadius = 16.0
        layer?.addSublayer(lowerCellLayer)
        
        upperCellLayer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 0.4, 0.4, 1.0])
        upperCellLayer.cornerRadius = 16.0
        layer?.addSublayer(upperCellLayer)
        
        updateLayerFrames()
    }
    
    
    // PUBLIC
    
    // @function    updateLayerFrames
    //
    func updateLayerFrames() {
        
        trackLayer.frame = bounds.rectByInsetting(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        lowerCellLayer.frame = CGRect(x: lowerThumbCenter - cellWidth / 2.0, y: 0.0, width: cellWidth, height: cellWidth)
        lowerCellLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperCellLayer.frame = CGRect(x: upperThumbCenter - cellWidth / 2.0, y: 0.0, width: cellWidth, height: cellWidth)
        upperCellLayer.setNeedsDisplay()
    }
    
    
    // INTERNAL
    
    // @function    positionForValue
    //
    internal func positionForValue(value: Double) -> Double {
        return Double(bounds.width - cellWidth) * (value - minValue) / (maxValue - minValue) + Double(cellWidth / 2.0)
    }
    
}
