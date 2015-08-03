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

    let horizontalRangeSlider: JMSRangeSlider = JMSRangeSlider(frame: CGRectZero)
    let verticalRangeSlider: JMSRangeSlider = JMSRangeSlider(frame: CGRectZero)
    
    let horizontalLine: NSBox = NSBox()
    
    let startMinValue: Double = -100
    let startMaxValue: Double = 100
    let startLowerValue: Double = -50
    let startUpperValue: Double = 50
    
    var chkCornerRadius: NSButton = NSButton()
    var txtVertical: NSTextField = NSTextField()
    var txtHorizontal: NSTextField = NSTextField()
    
    var horizontalCellsSideTop: NSButton = NSButton()
    var horizontalCellsSideBottom: NSButton = NSButton()
    
    var verticalCellsSideLeft: NSButton = NSButton()
    var verticalCellsSideRight: NSButton = NSButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add textfields
        self.addTextFields()
        
        // Add Range slider
        self.addRangeSlider()
        
        // Add vertical slider
        self.addVerticalRangeSlider()
        
        // Update text fields
        self.updateTextFields()
    }
    
    
    func addTextFields() {
        // Text
        txtHorizontal.frame = CGRectMake(20, self.view.frame.height - 90, 300, 70)
        txtHorizontal.bordered = false
        txtHorizontal.backgroundColor = nil
        txtHorizontal.selectable = false
        self.view.addSubview(txtHorizontal)
        
        // Corner Radius
        chkCornerRadius.frame = CGRectMake(300, self.view.frame.height - 40, 300, 30)
        chkCornerRadius.setButtonType(NSButtonType.SwitchButton)
        chkCornerRadius.title = "Corner Radius"
        chkCornerRadius.state = 1
        chkCornerRadius.action = "toggleCornerRadius:"
        self.view.addSubview(chkCornerRadius)
        
        // Cells Side
        horizontalCellsSideTop.frame = CGRectMake(300, chkCornerRadius.frame.origin.y - 40, 300, 30)
        horizontalCellsSideTop.setButtonType(NSButtonType.RadioButton)
        horizontalCellsSideTop.title = "Top"
        horizontalCellsSideTop.state = 1
        horizontalCellsSideTop.action = "toggleHorizontalCellsSide:"
        self.view.addSubview(horizontalCellsSideTop)
        
        horizontalCellsSideBottom.frame = CGRectMake(300, horizontalCellsSideTop.frame.origin.y - 20, 300, 30)
        horizontalCellsSideBottom.setButtonType(NSButtonType.RadioButton)
        horizontalCellsSideBottom.title = "Bottom"
        horizontalCellsSideBottom.state = 0
        horizontalCellsSideBottom.action = "toggleHorizontalCellsSide:"
        self.view.addSubview(horizontalCellsSideBottom)
        
        
        // Separator
        horizontalLine.frame = CGRectMake(10, txtHorizontal.frame.origin.y - 100, self.view.frame.width - 20, 2.0)
        self.view.addSubview(horizontalLine)
        
        // Text
        txtVertical.frame = CGRectMake(20, horizontalLine.frame.origin.y - 100, self.view.frame.width / 2, 80)
        txtVertical.bordered = false
        txtVertical.backgroundColor = nil
        txtVertical.selectable = false
        self.view.addSubview(txtVertical)
        
        
        // Cells Side
        verticalCellsSideLeft.frame = CGRectMake(20, txtVertical.frame.origin.y - 40, 300, 30)
        verticalCellsSideLeft.setButtonType(NSButtonType.RadioButton)
        verticalCellsSideLeft.title = "Left"
        verticalCellsSideLeft.state = 1
        verticalCellsSideLeft.action = "toggleVerticalCellsSide:"
        self.view.addSubview(verticalCellsSideLeft)
        
        verticalCellsSideRight.frame = CGRectMake(20, verticalCellsSideLeft.frame.origin.y - 20, 300, 30)
        verticalCellsSideRight.setButtonType(NSButtonType.RadioButton)
        verticalCellsSideRight.title = "Right"
        verticalCellsSideRight.state = 0
        verticalCellsSideRight.action = "toggleVerticalCellsSide:"
        self.view.addSubview(verticalCellsSideRight)
    }
    
    
    func updateTextFields() {
        txtHorizontal.stringValue = "Min: \(startMinValue) \nMax: \(startMaxValue) \nLower: \(horizontalRangeSlider.lowerValue) \nUpper: \(horizontalRangeSlider.upperValue)"
        txtVertical.stringValue = "Min: \(startMinValue) \nMax: \(startMaxValue) \nLower: \(verticalRangeSlider.lowerValue) \nUpper: \(verticalRangeSlider.upperValue)"
    }
    
    
    func toggleCornerRadius(sender: AnyObject) {
        horizontalRangeSlider.cornerRadius = chkCornerRadius.state == 1 ? 1.0: 0.0
    }
    
    func toggleHorizontalCellsSide(sender: AnyObject) {
        if sender as! NSButton == horizontalCellsSideTop {
            horizontalRangeSlider.cellsSide = JMSRangeSliderCellsSide.Top
        } else {
            horizontalRangeSlider.cellsSide = JMSRangeSliderCellsSide.Bottom
        }
    }
    
    func toggleVerticalCellsSide(sender: AnyObject) {
        if sender as! NSButton == verticalCellsSideLeft {
            verticalRangeSlider.cellsSide = JMSRangeSliderCellsSide.Left
        } else {
            verticalRangeSlider.cellsSide = JMSRangeSliderCellsSide.Right
        }
    }
    
    
    
    func addRangeSlider() {
        let margin: CGFloat = 20.0
        let width = self.view.bounds.width - 2.0 * margin
        
        horizontalRangeSlider.cellsSide = JMSRangeSliderCellsSide.Bottom
        horizontalRangeSlider.trackHighlightTintColor = NSColor(red: 0.4, green: 0.698, blue: 1.0, alpha: 1.0)
        horizontalRangeSlider.minValue = startMinValue
        horizontalRangeSlider.maxValue = startMaxValue
        horizontalRangeSlider.lowerValue = startLowerValue
        horizontalRangeSlider.upperValue = startUpperValue
        horizontalRangeSlider.cornerRadius = 1.0
        horizontalRangeSlider.frame = CGRect(x: margin, y: txtHorizontal.frame.origin.y - txtHorizontal.frame.height, width: width, height: 40.0)
        horizontalRangeSlider.action = "updateRange:"
        horizontalRangeSlider.target = self
        
        self.view.addSubview(horizontalRangeSlider)
        
        self.view.wantsLayer = true
    }
    
    
    func addVerticalRangeSlider() {
        verticalRangeSlider.direction = JMSRangeSliderDirection.Vertical
        verticalRangeSlider.trackHighlightTintColor = NSColor(red: 1, green: 0.48, blue: 0.4, alpha: 1.0)
        verticalRangeSlider.minValue = startMinValue
        verticalRangeSlider.maxValue = startMaxValue
        verticalRangeSlider.lowerValue = startLowerValue
        verticalRangeSlider.upperValue = startUpperValue
        verticalRangeSlider.cornerRadius = 1.0
        verticalRangeSlider.frame = CGRectMake(300, horizontalLine.frame.origin.y - 290, 40, 270)
        verticalRangeSlider.action = "updateRange:"
        verticalRangeSlider.target = self
        
        self.view.addSubview(verticalRangeSlider)
        self.view.wantsLayer = true
    }

    
    func updateRange(sender: AnyObject) {
        self.updateTextFields()
    }

}

