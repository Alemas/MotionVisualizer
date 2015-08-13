//
//  CustomView.swift
//  MotionVisualizer
//
//  Created by Mateus Reckziegel on 8/13/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import Cocoa

class CustomView: NSView {
    
    var values:NSArray?
    var time = 0
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.layer?.frame = self.frame
        self.layer?.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        

    }
    
    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
        
        CGContextClearRect(ctx, layer.frame)
        
        var path = NSBezierPath()
        
        path.moveToPoint(CGPointMake(0, 0))
        path.lineToPoint(CGPointMake(layer.frame.width, layer.frame.height))

        path.stroke()
        
    }
    
}
