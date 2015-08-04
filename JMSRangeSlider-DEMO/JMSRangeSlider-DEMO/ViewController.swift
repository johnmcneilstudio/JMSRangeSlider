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
    
    var horizontalCornerRadius: NSButton = NSButton()
    var txtHorizontal: NSTextField = NSTextField()
    
    var verticalCornerRadius: NSButton = NSButton()
    var txtVertical: NSTextField = NSTextField()
    
    var horizontalCellsSideTop: NSButton = NSButton()
    var horizontalCellsSideBottom: NSButton = NSButton()
    
    var verticalCellsSideLeft: NSButton = NSButton()
    var verticalCellsSideRight: NSButton = NSButton()
    
    let marginElements: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add horizontal elements
        self.addHorizontalElements()
        
        // Add Range slider
        self.addRangeSlider()
        
        // Add vertical elements
        self.addVerticalElements()
        
        // Add vertical slider
        self.addVerticalRangeSlider()
        
        // Update text fields
        self.updateTextFields()
    }
    
    
    func addHorizontalElements() {
        // Text
        txtHorizontal.frame = CGRectMake(20, self.view.frame.height - 90, 300, 70)
        txtHorizontal.bordered = false
        txtHorizontal.backgroundColor = nil
        txtHorizontal.selectable = false
        self.view.addSubview(txtHorizontal)
        
        // Corner Radius
        horizontalCornerRadius.frame = CGRectMake(self.view.frame.width / 2, self.view.frame.height - 40, 300, 30)
        horizontalCornerRadius.setButtonType(NSButtonType.SwitchButton)
        horizontalCornerRadius.title = "Corner Radius ?"
        horizontalCornerRadius.state = 0
        horizontalCornerRadius.action = "toggleCornerRadius:"
        self.view.addSubview(horizontalCornerRadius)
        
        // Cells Side
        horizontalCellsSideTop.frame = CGRectMake(self.view.frame.width / 2, horizontalCornerRadius.frame.origin.y - 2 * marginElements, 300, 30)
        horizontalCellsSideTop.setButtonType(NSButtonType.RadioButton)
        horizontalCellsSideTop.title = "Top"
        horizontalCellsSideTop.state = 1
        horizontalCellsSideTop.action = "toggleHorizontalCellsSide:"
        self.view.addSubview(horizontalCellsSideTop)
        
        horizontalCellsSideBottom.frame = CGRectMake(self.view.frame.width / 2, horizontalCellsSideTop.frame.origin.y - marginElements, 300, 30)
        horizontalCellsSideBottom.setButtonType(NSButtonType.RadioButton)
        horizontalCellsSideBottom.title = "Bottom"
        horizontalCellsSideBottom.state = 0
        horizontalCellsSideBottom.action = "toggleHorizontalCellsSide:"
        self.view.addSubview(horizontalCellsSideBottom)
    }
    
    
    func addVerticalElements() {
        // Separator
        horizontalLine.frame = CGRectMake(marginElements, horizontalRangeSlider.frame.origin.y - marginElements, self.view.frame.width - 2 * marginElements, 2.0)
        self.view.addSubview(horizontalLine)
        
        // Text
        txtVertical.frame = CGRectMake(marginElements, horizontalLine.frame.origin.y - 80 - marginElements, self.view.frame.width / 2, 80)
        txtVertical.bordered = false
        txtVertical.backgroundColor = nil
        txtVertical.selectable = false
        self.view.addSubview(txtVertical)
        
        // Corner Radius
        verticalCornerRadius.frame = CGRectMake(marginElements, txtVertical.frame.origin.y - 2 * marginElements, self.view.frame.width / 2, 30)
        verticalCornerRadius.setButtonType(NSButtonType.SwitchButton)
        verticalCornerRadius.title = "Corner Radius ?"
        verticalCornerRadius.state = 0
        verticalCornerRadius.action = "toggleCornerRadius:"
        self.view.addSubview(verticalCornerRadius)
        
        // Cells Side
        verticalCellsSideLeft.frame = CGRectMake(marginElements, verticalCornerRadius.frame.origin.y - 2 * marginElements, self.view.frame.width / 2, 30)
        verticalCellsSideLeft.setButtonType(NSButtonType.RadioButton)
        verticalCellsSideLeft.title = "Left"
        verticalCellsSideLeft.state = 1
        verticalCellsSideLeft.action = "toggleVerticalCellsSide:"
        self.view.addSubview(verticalCellsSideLeft)
        
        verticalCellsSideRight.frame = CGRectMake(marginElements, verticalCellsSideLeft.frame.origin.y - marginElements, self.view.frame.width / 2, 30)
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
        if sender as? NSButton == horizontalCornerRadius {
            horizontalRangeSlider.cornerRadius = horizontalCornerRadius.state == 1 ? 1.0: 0.0
        } else {
            verticalRangeSlider.cornerRadius = verticalCornerRadius.state == 1 ? 1.0: 0.0
        }
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
        let cellWidth: CGFloat = 20
        let cellHeight: CGFloat = 30
        let trackThickness: CGFloat = 10
        
        horizontalRangeSlider.cellWidth = cellWidth
        horizontalRangeSlider.cellHeight = cellHeight
        horizontalRangeSlider.trackThickness = trackThickness
        horizontalRangeSlider.cellsSide = JMSRangeSliderCellsSide.Top
        horizontalRangeSlider.trackHighlightTintColor = NSColor(red: 0.4, green: 0.698, blue: 1.0, alpha: 1.0)
        horizontalRangeSlider.minValue = startMinValue
        horizontalRangeSlider.maxValue = startMaxValue
        horizontalRangeSlider.lowerValue = startLowerValue
        horizontalRangeSlider.upperValue = startUpperValue
        horizontalRangeSlider.cornerRadius = CGFloat(horizontalCornerRadius.state)
        horizontalRangeSlider.frame = CGRect(x: cellWidth, y: txtHorizontal.frame.origin.y - txtHorizontal.frame.height - marginElements, width: self.view.bounds.width - 2 * cellWidth, height: 2 * cellHeight + trackThickness)
        horizontalRangeSlider.action = "updateRange:"
        horizontalRangeSlider.target = self
        
        self.view.addSubview(horizontalRangeSlider)
        self.view.wantsLayer = true
    }
    
    
    func addVerticalRangeSlider() {
        let cellWidth: CGFloat = 30
        let cellHeight: CGFloat = 20
        let trackThickness: CGFloat = 10
        
        verticalRangeSlider.cellWidth = cellWidth
        verticalRangeSlider.cellHeight = cellHeight
        verticalRangeSlider.trackThickness = trackThickness
        verticalRangeSlider.direction = JMSRangeSliderDirection.Vertical
        verticalRangeSlider.trackHighlightTintColor = NSColor(red: 1, green: 0.48, blue: 0.4, alpha: 1.0)
        verticalRangeSlider.minValue = startMinValue
        verticalRangeSlider.maxValue = startMaxValue
        verticalRangeSlider.lowerValue = startLowerValue
        verticalRangeSlider.upperValue = startUpperValue
        verticalRangeSlider.cornerRadius = CGFloat(verticalCornerRadius.state)
        verticalRangeSlider.frame = CGRectMake(self.view.frame.width / 2, horizontalLine.frame.origin.y - 190, 2 * cellWidth + trackThickness, 170)
        verticalRangeSlider.action = "updateRange:"
        verticalRangeSlider.target = self
        
        self.view.addSubview(verticalRangeSlider)
        self.view.wantsLayer = true
    }

    
    func updateRange(sender: AnyObject) {
        self.updateTextFields()
    }

}

