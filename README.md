# JMS Range Slider

> A custom Range Slider for OSX

![Screenshot JMSRangeSlider](screenshot.png)

## [CHANGELOG](./CHANGELOG.md)

## EXAMPLE

```swift
let rangeSlider: JMSRangeSlider = JMSRangeSlider(frame: CGRectZero)
rangeSlider.minValue = 0
rangeSlider.maxValue = 100
rangeSlider.lowerValue = 25
rangeSlider.upperValue = 75
rangeSlider.trackHighlightTintColor = NSColor(red: 0.4, green: 0.698, blue: 1.0, alpha: 1.0)
rangeSlider.curvaceousness = 1.0
rangeSlider.frame = CGRect(x: 20.0, y: 20.0, width: self.bounds.width, height: 30.0)
rangeSlider.action = "updateRange:"
rangeSlider.target = self
self.addSubview(rangeSlider)

func updateRange(sender: AnyObject) {
    NSLog("Lower value = \(rangeSlider.lowerValue)")
    NSLog("Upper value = \(rangeSlider.upperValue)")
}
```

## PROPERTIES

```minValue```  
Minimum value  
Type ```Double```  
_Optional_  
Default: 0  

```maxValue```  
Maximum value  
Type ```Double```  
_Optional_  
Default: 1  

```lowerValue```  
Initial lower value  
Type ```Double```  
_Optional_  
Default: ```minValue```  

```upperValue```  
Initial upper value  
Type ```Double```  
_Optional_  
Default: ```maxValue```  

```trackTintColor```  
Tint color of track  
Type ```NSColor```  
_Optional_  
Default: ```white:0.8, alpha:1```  

```trackHighlightTintColor```  
Highlight tint color of track  
Type ```NSColor```  
_Optional_  
Default: ```rgba(0,0,0,1)```  

```cellTintColor```  
Tint color of cells  
Type ```NSColor```  
_Optional_  
Default: ```white```  

```cornerRadius```  
Corner radius of cell  
Type ```CGFloat```  
_Optional_  
Default: ```1```  


