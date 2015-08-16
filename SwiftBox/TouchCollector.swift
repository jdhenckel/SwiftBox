//
//  TouchSet.swift
//  SwiftBox
//
//  Created by John Henckel on 8/9/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import UIKit

/*
The purpose of this class is to collect touches, as they happen, from the
primitive callbacks (began, moved, etc). It maintains a list of current
touches, in a simple array, sorted by the age of the touch (oldest first).
It could also maintain statistics, like age and velocity for each touch.
It also can take a client, which will be invoked during the update().
You're supposed to call the update once per frame repaint (e.g. in your
SKScene update)
*/
class TouchCollector {
    
    var touches: [UITouch] = []
    var client: TouchClient
    
    private let BeginFlag = 1
    private let ChangeFlag = 2
    private let EndFlag = 4
    
    private var flags = 0
    private var holdCounter: Int = 0
    private let longTouchThreshold = 100
    
    init(_ client: TouchClient) {
        self.client = client
    }
    
    func begin(touch:UITouch) {
        flags |= touches.count == 0 ? BeginFlag : ChangeFlag
        if find(touch) == -1 {
            touches.append(touch)
        }
    }
    
    func move(touch:UITouch) {
        if find(touch) >= 0 {
            flags |= ChangeFlag
        }
    }
    
    func end(touch:UITouch) {
        let i = find(touch)
        flags |= i == 0 ? EndFlag : i > 0 ? ChangeFlag : 0
    }
    
    func cancel(touch:UITouch) {
        end(touch)
    }
    
    func clear() {
        touches.removeAll(keepCapacity: true)
    }
    
    func removeAllDead() {
        // remove any touches that are ended or cancelled
        for var i = touches.count - 1; i >= 0; --i {
            let p = touches[i].phase
            if p == .Ended || p == .Cancelled {
                touches.removeAtIndex(i)
            }
        }
    }
    
    func update() {
        // No touches
        if touches.count == 0 {
            return
        }
        if flags == 0 {
            // Nothing has changed since last update
            holdCounter++
            if holdCounter == longTouchThreshold {
                client.longTouch(self)
            }
            return
        }
        holdCounter = 0
        
        // Something changed: Call appropriate client function
        if flags & BeginFlag != 0 {
            client.beginFirstTouch(self)
        }
        if flags & EndFlag != 0 {
            client.endFirstTouch(self)
        }
        else if flags & ChangeFlag != 0 {
            client.changeTouch(self)
        }
        flags = 0
        removeAllDead()
    }
    
    private func find(touch:UITouch) -> Int {
        for (i, t) in enumerate(touches) {
            if t === touch {
                return i
            }
        }
        return -1
    }
}




