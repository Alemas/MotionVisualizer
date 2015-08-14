//
//  CustomView.swift
//  MotionVisualizer
//
//  Created by Mateus Reckziegel on 8/13/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import Cocoa

class CustomView: NSView {
    
    private var lastValues = [Float(0), Float(0), Float(0), Float(0)]
    private var paths = NSMutableArray(array:[CGPathCreateMutable(), CGPathCreateMutable(), CGPathCreateMutable()])
    var values:NSArray?
    var time = 0
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
        
        if self.values == nil {
            return
        }
        
        var color:CGColorRef
        
        if self.time == 0 {
            CGContextClearRect(ctx, self.frame)
            self.paths = [CGPathCreateMutable(), CGPathCreateMutable(), CGPathCreateMutable()]
        }
        
//        CGContextClearRect(ctx, layer.frame)
        
        for var i = 1; i < 4; i++ {
            
            switch i {
            case 1: // X = RED
                color = CGColorCreateGenericRGB(1.0, 0.0, 0.0, 1.0)
            case 2: // Y = YELLOW
                color = CGColorCreateGenericRGB(0.0, 1.0, 0.0, 1.0)
            case 3: // Z = BLUE
                color = CGColorCreateGenericRGB(0.0, 0.0, 1.0, 1.0)
            default: // BLACK
                color = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0)
            }
            
            let x0 = CGFloat(self.time - 1)
            let y0 = CGFloat(self.lastValues[i]) * self.frame.size.height/2
 + self.frame.size.height/2
            let x1 = CGFloat(self.time)
            let y1 = CGFloat(self.values![i] as! NSNumber) * self.frame.size.height/2
 + self.frame.size.height/2
            
            let path = self.paths[i-1] as! CGMutablePathRef
            
            if self.time == 0 {
                CGPathMoveToPoint(path, nil, x0, y0)
            }
            
            CGPathMoveToPoint(path, nil, x0, y0)
            CGPathAddLineToPoint(path, nil, x1, y1)
            CGContextAddPath(ctx, path)
            CGContextSetStrokeColorWithColor(ctx, color)
            CGContextStrokePath(ctx)
            
//            println("x0 = \(x0), y0 = \(y0), x1 = \(x1), y1 = \(y1)")
            
//            CGContextSetStrokeColorWithColor(ctx, color)
            
//            CGContextBeginPath(ctx)
////            CGContextTranslateCTM(ctx, 0.0, self.frame.size.height/2)
//            CGContextMoveToPoint(ctx, x0, y0)
//            CGContextAddLineToPoint(ctx, x1, y1)
//            CGContextStrokePath(ctx)
            
        }
        
        self.lastValues = self.values! as! [Float]
        
    }
    
}
