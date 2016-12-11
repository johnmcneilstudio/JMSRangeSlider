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

    let horizontalRangeSlider: JMSRangeSlider = JMSRangeSlider(frame: CGRect.zero)
    let verticalRangeSlider: JMSRangeSlider = JMSRangeSlider(frame: CGRect.zero)
    
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
    var horizontalCellsSideCenter: NSButton = NSButton()
    
    var verticalCellsSideLeft: NSButton = NSButton()
    var verticalCellsSideRight: NSButton = NSButton()
    var verticalCellsSideCenter: NSButton = NSButton()
    
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
    
    // @function        addHorizontalElements
    // Add horizontal elements
    //
    func addHorizontalElements() {
        // Text
        txtHorizontal.frame = CGRect(x: 20, y: self.view.frame.height - 90, width: self.view.frame.width / 2 - marginElements, height: 70)
        txtHorizontal.isBordered = false
        txtHorizontal.backgroundColor = nil
        txtHorizontal.isSelectable = false
        self.view.addSubview(txtHorizontal)
        
        // Corner Radius
        horizontalCornerRadius.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height - 40, width: 300, height: 30)
        horizontalCornerRadius.setButtonType(NSButtonType.switch)
        horizontalCornerRadius.title = "Corner Radius ?"
        horizontalCornerRadius.state = 0
        horizontalCornerRadius.action = #selector(ViewController.toggleCornerRadius(_:))
        self.view.addSubview(horizontalCornerRadius)
        
        // Cells Side
        horizontalCellsSideTop.frame = CGRect(x: self.view.frame.width / 2, y: horizontalCornerRadius.frame.origin.y - marginElements, width: 300, height: 30)
        horizontalCellsSideTop.setButtonType(NSButtonType.radio)
        horizontalCellsSideTop.title = "Top"
        horizontalCellsSideTop.state = 1
        horizontalCellsSideTop.action = #selector(ViewController.toggleHorizontalCellsSide(_:))
        self.view.addSubview(horizontalCellsSideTop)
        
        horizontalCellsSideBottom.frame = CGRect(x: self.view.frame.width / 2, y: horizontalCellsSideTop.frame.origin.y - marginElements, width: 300, height: 30)
        horizontalCellsSideBottom.setButtonType(NSButtonType.radio)
        horizontalCellsSideBottom.title = "Bottom"
        horizontalCellsSideBottom.state = 0
        horizontalCellsSideBottom.action = #selector(ViewController.toggleHorizontalCellsSide(_:))
        self.view.addSubview(horizontalCellsSideBottom)
        
        horizontalCellsSideCenter.frame = CGRect(x: self.view.frame.width / 2, y: horizontalCellsSideBottom.frame.origin.y - marginElements, width: 300, height: 30)
        horizontalCellsSideCenter.setButtonType(NSButtonType.radio)
        horizontalCellsSideCenter.title = "Center"
        horizontalCellsSideCenter.state = 0
        horizontalCellsSideCenter.action = #selector(ViewController.toggleHorizontalCellsSide(_:))
        self.view.addSubview(horizontalCellsSideCenter)
    }
    
    // @function        addVerticalElements
    // Add vertical elements
    //
    func addVerticalElements() {
        // Separator
        horizontalLine.frame = CGRect(x: marginElements, y: horizontalRangeSlider.frame.origin.y - marginElements, width: self.view.frame.width - 2 * marginElements, height: 2.0)
        self.view.addSubview(horizontalLine)
        
        // Text
        txtVertical.frame = CGRect(x: marginElements, y: horizontalLine.frame.origin.y - 80 - marginElements, width: self.view.frame.width / 2, height: 80)
        txtVertical.isBordered = false
        txtVertical.backgroundColor = nil
        txtVertical.isSelectable = false
        self.view.addSubview(txtVertical)
        
        // Corner Radius
        verticalCornerRadius.frame = CGRect(x: marginElements, y: txtVertical.frame.origin.y - 2 * marginElements, width: self.view.frame.width / 2, height: 30)
        verticalCornerRadius.setButtonType(NSButtonType.switch)
        verticalCornerRadius.title = "Corner Radius ?"
        verticalCornerRadius.state = 0
        verticalCornerRadius.action = #selector(ViewController.toggleCornerRadius(_:))
        self.view.addSubview(verticalCornerRadius)
        
        // Cells Side
        verticalCellsSideLeft.frame = CGRect(x: marginElements, y: verticalCornerRadius.frame.origin.y - 2 * marginElements, width: self.view.frame.width / 2, height: 30)
        verticalCellsSideLeft.setButtonType(NSButtonType.radio)
        verticalCellsSideLeft.title = "Left"
        verticalCellsSideLeft.state = 1
        verticalCellsSideLeft.action = #selector(ViewController.toggleVerticalCellsSide(_:))
        self.view.addSubview(verticalCellsSideLeft)
        
        verticalCellsSideRight.frame = CGRect(x: marginElements, y: verticalCellsSideLeft.frame.origin.y - marginElements, width: self.view.frame.width / 2, height: 30)
        verticalCellsSideRight.setButtonType(NSButtonType.radio)
        verticalCellsSideRight.title = "Right"
        verticalCellsSideRight.state = 0
        verticalCellsSideRight.action = #selector(ViewController.toggleVerticalCellsSide(_:))
        self.view.addSubview(verticalCellsSideRight)
        
        verticalCellsSideCenter.frame = CGRect(x: marginElements, y: verticalCellsSideRight.frame.origin.y - marginElements, width: self.view.frame.width / 2, height: 30)
        verticalCellsSideCenter.setButtonType(NSButtonType.radio)
        verticalCellsSideCenter.title = "Center"
        verticalCellsSideCenter.state = 0
        verticalCellsSideCenter.action = #selector(ViewController.toggleVerticalCellsSide(_:))
        self.view.addSubview(verticalCellsSideCenter)
    }
    
    // @function        updateTextFields
    // Update text fields
    //
    func updateTextFields() {
        txtHorizontal.stringValue = "Min: \(startMinValue) \nMax: \(startMaxValue) \nLower: \(horizontalRangeSlider.lowerValue) \nUpper: \(horizontalRangeSlider.upperValue)"
        txtVertical.stringValue = "Min: \(startMinValue) \nMax: \(startMaxValue) \nLower: \(verticalRangeSlider.lowerValue) \nUpper: \(verticalRangeSlider.upperValue)"
    }
    
    // @function        toggleCornerRadius
    // Toggle Corner Radius
    //
    func toggleCornerRadius(_ sender: AnyObject) {
        if sender as? NSButton == horizontalCornerRadius {
            horizontalRangeSlider.trackCornerRadius = horizontalCornerRadius.state == 1 ? 1.0: 0.0
        } else {
            verticalRangeSlider.trackCornerRadius = verticalCornerRadius.state == 1 ? 1.0: 0.0
        }
    }
    
    // @function        toggleHorizontalCellsSide
    // Toggle horizontal range slider cells side
    //
    func toggleHorizontalCellsSide(_ sender: AnyObject) {
        if sender as! NSButton == horizontalCellsSideTop {
            horizontalRangeSlider.cellsSide = JMSRangeSliderCellsSide.top
        } else if sender as! NSButton == horizontalCellsSideBottom {
            horizontalRangeSlider.cellsSide = JMSRangeSliderCellsSide.bottom
        } else {
            horizontalRangeSlider.cellsSide = JMSRangeSliderCellsSide.centerHoriz
        }
    }
    
    // @function        toggleVerticalCellsSide
    // Toggle vertical range slider cells side
    //
    func toggleVerticalCellsSide(_ sender: AnyObject) {
        if sender as! NSButton == verticalCellsSideLeft {
            verticalRangeSlider.cellsSide = JMSRangeSliderCellsSide.left
        } else if sender as! NSButton == verticalCellsSideRight {
            verticalRangeSlider.cellsSide = JMSRangeSliderCellsSide.right
        } else {
            verticalRangeSlider.cellsSide = JMSRangeSliderCellsSide.centerVert
        }
    }
    
    
    // @function        addRangeSlider
    // Add horizontal range slider
    //
    func addRangeSlider() {
        let cellWidth: CGFloat = 20
        let cellHeight: CGFloat = 30
        let trackThickness: CGFloat = 10
        
        horizontalRangeSlider.cellWidth = cellWidth
        horizontalRangeSlider.cellHeight = cellHeight
        horizontalRangeSlider.trackThickness = trackThickness
        horizontalRangeSlider.cellsSide = JMSRangeSliderCellsSide.top
        horizontalRangeSlider.trackHighlightTintColor = NSColor(red: 0.4, green: 0.698, blue: 1.0, alpha: 1.0)
        horizontalRangeSlider.minValue = startMinValue
        horizontalRangeSlider.maxValue = startMaxValue
        horizontalRangeSlider.lowerValue = startLowerValue
        horizontalRangeSlider.upperValue = startUpperValue
        horizontalRangeSlider.trackCornerRadius = CGFloat(horizontalCornerRadius.state)
        horizontalRangeSlider.frame = CGRect(x: cellWidth, y: txtHorizontal.frame.origin.y - cellHeight - trackThickness - marginElements, width: self.view.bounds.width - 2 * cellWidth, height: cellHeight + trackThickness)
        horizontalRangeSlider.action = #selector(ViewController.updateRange(_:))
        horizontalRangeSlider.target = self
        
        self.view.addSubview(horizontalRangeSlider)
        self.view.wantsLayer = true
    }
    
    
    // @function        addVerticalRangeSlider
    // Add vertical range slider
    //
    func addVerticalRangeSlider() {
        let cellWidth: CGFloat = 30
        let cellHeight: CGFloat = 20
        let trackThickness: CGFloat = 10
        
        verticalRangeSlider.cellWidth = cellWidth
        verticalRangeSlider.cellHeight = cellHeight
        verticalRangeSlider.trackThickness = trackThickness
        verticalRangeSlider.direction = JMSRangeSliderDirection.vertical
        verticalRangeSlider.trackHighlightTintColor = NSColor(red: 1, green: 0.48, blue: 0.4, alpha: 1.0)
        verticalRangeSlider.minValue = startMinValue
        verticalRangeSlider.maxValue = startMaxValue
        verticalRangeSlider.lowerValue = startLowerValue
        verticalRangeSlider.upperValue = startUpperValue
        verticalRangeSlider.trackCornerRadius = CGFloat(verticalCornerRadius.state)
        verticalRangeSlider.frame = CGRect(x: self.view.frame.width / 2, y: horizontalLine.frame.origin.y - 190, width: cellWidth + trackThickness, height: 170)
        verticalRangeSlider.action = #selector(ViewController.updateRange(_:))
        verticalRangeSlider.target = self
        
        self.view.addSubview(verticalRangeSlider)
        self.view.wantsLayer = true
    }

    
    // @function        updateRange
    // Called on range slider update
    //
    func updateRange(_ sender: AnyObject) {
        self.updateTextFields()
    }

}

// Note: For some reason, makeTouchBar() is not being called, but I don't have time to 
// figure out why. This is exactly how I have it implemented in another app, so no idea.
// But this is still good example code for implemenation in other apps.

@available(OSX 10.12.1, *)
fileprivate extension NSTouchBarItemIdentifier {
    static var rangeSlider = NSTouchBarItemIdentifier("com.jms.JMSRangeSlider.rangeSlider")
}

@available(OSX 10.12.1, *)
extension ViewController : NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.rangeSlider]
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        if identifier == .rangeSlider {
            return JMSRangeSlider.touchBarItem(identifier: identifier, width: 260.0, target: self, action: #selector(touchBarRangeChanged(_:)))
        }
        return nil
    }
    
    @objc fileprivate func touchBarRangeChanged(_ sender: JMSRangeSlider) {
        Swift.print("TOUCH BAR lower: \(sender.lowerValue)  upper: \(sender.upperValue)")
    }
}

