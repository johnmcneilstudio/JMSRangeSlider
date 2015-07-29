//
//  ViewController.swift
//  JMSRangeSlider-DEMO
//
//  Created by Matthieu Collé on 28/07/2015.
//  Copyright © 2015 JohnMcNeil Studio. All rights reserved.
//

import Cocoa
import JMSRangeSlider

class ViewController: NSViewController {

    let rangeSlider: JMSRangeSlider = JMSRangeSlider(frame: CGRectZero)
    
    let startMinValue: Double = -100
    let startMaxValue: Double = 100
    let startLowerValue: Double = -50
    let startUpperValue: Double = 50
    
    var txtMinVal: NSTextField = NSTextField()
    var txtMaxVal: NSTextField = NSTextField()
    var txtLowerVal: NSTextField = NSTextField()
    var txtUpperVal: NSTextField = NSTextField()
    var chkCornerRadius: NSButton = NSButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Range slider
        self.addRangeSlider()
        
        // Add textfields
        self.initTextFields()
        self.updateTextFields()
    }
    
    func initTextFields() {
        txtMinVal.frame = CGRectMake(15, self.view.frame.height - 40, 300, 30.0)
        txtMinVal.bordered = false
        txtMinVal.backgroundColor = nil
        txtMinVal.selectable = false
        self.view.addSubview(txtMinVal)
        
        txtMaxVal.frame = CGRectMake(15, self.view.frame.height - 65, 300, 30.0)
        txtMaxVal.bordered = false
        txtMaxVal.backgroundColor = nil
        txtMaxVal.selectable = false
        self.view.addSubview(txtMaxVal)
        
        txtLowerVal.frame = CGRectMake(15, self.view.frame.height - 90, 300, 30.0)
        txtLowerVal.bordered = false
        txtLowerVal.backgroundColor = nil
        txtLowerVal.selectable = false
        self.view.addSubview(txtLowerVal)
        
        txtUpperVal.frame = CGRectMake(15, self.view.frame.height - 115, 300, 30.0)
        txtUpperVal.bordered = false
        txtUpperVal.backgroundColor = nil
        txtUpperVal.selectable = false
        self.view.addSubview(txtUpperVal)
        
        chkCornerRadius.frame = CGRectMake(300, self.view.frame.height - 40, 300, 30.0)
        chkCornerRadius.setButtonType(NSButtonType.SwitchButton)
        chkCornerRadius.title = "Corner Radius"
        chkCornerRadius.state = 1
        chkCornerRadius.action = "toggleCornerRadius:"
        self.view.addSubview(chkCornerRadius)
    }
    
    func updateTextFields() {
        txtMinVal.stringValue =     "Min    : \(startMinValue)"
        txtMaxVal.stringValue =     "Max    : \(startMaxValue)"
        txtLowerVal.stringValue =   "Lower  : \(rangeSlider.lowerValue)"
        txtUpperVal.stringValue =   "Upper  : \(rangeSlider.upperValue)"
    }
    
    func toggleCornerRadius(sender: AnyObject) {
        rangeSlider.cornerRadius = chkCornerRadius.state == 1 ? 1.0: 0.0
    }
    
    func addRangeSlider() {
        let margin: CGFloat = 20.0
        let width = self.view.bounds.width - 2.0 * margin
        
        rangeSlider.trackHighlightTintColor = NSColor(red: 0.4, green: 0.698, blue: 1.0, alpha: 1.0)
        rangeSlider.minValue = startMinValue
        rangeSlider.maxValue = startMaxValue
        rangeSlider.lowerValue = startLowerValue
        rangeSlider.upperValue = startUpperValue
        rangeSlider.cornerRadius = 1.0
        rangeSlider.frame = CGRect(x: margin, y: margin, width: width, height: 40.0)
        rangeSlider.action = "updateRange:"
        rangeSlider.target = self
        
        self.view.addSubview(rangeSlider)
        
        self.view.wantsLayer = true
    }

    
    func updateRange(sender: AnyObject) {
        
        self.updateTextFields()
        
    }


}

