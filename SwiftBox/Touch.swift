//
//  Touch.swift
//  SwiftBox
//
//  Created by John Henckel on 7/27/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

class Touch {
    var touch: UITouch? = nil
    var moved: Bool = false
    var pos: CGPoint
    var bodyId: Int = -1
    var offset: CGPoint = CGPoint(x: 0, y: 0)
    
    init(uit: UITouch, pos:CGPoint) {
        self.touch = uit
        self.pos = pos
    }
}