//
//  Touch.swift
//  SwiftBox
//
//  Created by John Henckel on 7/27/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class Touch : Printable {
    var touch: UITouch!
    var startPos: CGPoint
    var endPos: CGPoint = CGPoint(x: 0, y: 0)
    var bodyId: Int = -1
    var moved: Int = 0
    var startTime: CFTimeInterval
    
    init(uit: UITouch, pos:CGPoint) {
        touch = uit
        startPos = pos
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    var description : String {
        return "{\(moved), \(startPos), \(endPos), \(bodyId), \(startTime)}"
    }

}