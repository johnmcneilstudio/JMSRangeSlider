//
//  ViewController.swift
//  JMSRangeSlider
//
//  Created by Matthieu Collé on 23/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa

class MainView: NSView {

    let rangeSlider: JMSRangeSlider = JMSRangeSlider(frame: CGRectZero)
    
    @IBOutlet weak var txtMinVal: NSTextField?
    @IBOutlet weak var txtMaxVal: NSTextField?
    @IBOutlet weak var txtLowerVal: NSTextField?
    @IBOutlet weak var txtUpperVal: NSTextField?
    
    let startMinValue: Double = -100
    let startMaxValue: Double = 100
    let startLowerValue: Double = -50
    let startUpperValue: Double = 50
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let margin: CGFloat = 20.0
        let width = self.bounds.width - 2.0 * margin
        
        rangeSlider.minValue = startMinValue
        rangeSlider.maxValue = startMaxValue
        rangeSlider.lowerValue = startLowerValue
        rangeSlider.upperValue = startUpperValue
        rangeSlider.trackHighlightTintColor = NSColor(red: 0.4, green: 0.698, blue: 1.0, alpha: 1.0)
        rangeSlider.cornerRadius = 1.0
        rangeSlider.frame = CGRect(x: margin, y: margin, width: width, height: 31.0)
        rangeSlider.action = "updateRange:"
        rangeSlider.target = self
        
        self.addSubview(rangeSlider)
        
        self.wantsLayer = true
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Text fields
        txtMinVal?.doubleValue = startMinValue
        txtMaxVal?.doubleValue = startMaxValue
        txtLowerVal?.doubleValue = startLowerValue
        txtUpperVal?.doubleValue = startUpperValue
        
    }
    
    func updateRange(sender: AnyObject) {
        
        txtLowerVal?.doubleValue = rangeSlider.lowerValue
        txtUpperVal?.doubleValue = rangeSlider.upperValue
        
    }
    
}
