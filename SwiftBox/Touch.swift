//
//  Touch.swift
//  SwiftBox
//
//  Created by John Henckel on 7/27/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class Touch : Printable {
    
    enum Event { case None, Began, Moved, Ended }
    
    var touch: UITouch!
    var startPos: CGPoint
    var endPos: CGPoint = CGPoint(x: 0, y: 0)
 //   var bodyId: Int = -1
    var moved: Bool = false    // used by update
    var moveCount: Int = 0      // total number of moves
    var stopCount: Int = 0      // number of updates since last move
    var startTime: CFTimeInterval
    
    init(uit: UITouch, pos:CGPoint) {
        touch = uit
        startPos = pos
        startTime = CACurrentMediaTime()
    }
    
    var description : String {
        // for debugging
        return "{m=\(moveCount), s=\(stopCount)}"
    }

    
    func update(currentTime: CFTimeInterval) {
        if moved {
            moved = false
            ++moveCount
            stopCount = 0
        }
        else {
            ++stopCount
        }
    }
}