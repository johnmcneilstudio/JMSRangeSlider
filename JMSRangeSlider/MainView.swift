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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubview(rangeSlider)
        
        let margin: CGFloat = 20.0
        let width = self.bounds.width - 2.0 * margin
        
        rangeSlider.frame = CGRect(x: margin, y: margin, width: width, height: 31.0)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        NSLog("drawRect")
        
    }
    
}
