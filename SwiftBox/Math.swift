//
//  Math.swift
//  SwiftBox
//
//  Created by John Henckel on 7/27/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit

extension CGPoint {
    
    func dot(v: CGPoint) -> CGFloat { return self.x * v.x + self.y * v.y }
    func dot2(x: CGFloat, y: CGFloat) -> CGFloat { return self.x * x + self.y * y }
    func lensq() -> CGFloat { return dot(self) }
    func length() -> CGFloat { return hypot(x, y) }
    func distance(a:CGPoint) -> CGFloat { return (self - a).length() }
    func distsq(a:CGPoint) -> CGFloat { return (self - a).lensq() }
    func angle() -> CGFloat { return atan2(y,x) }

    func isPositive() -> Bool { return x>0 && y>0 }
    func isNotNegative() -> Bool { return x>=0 && y>=0 }
    
    func direction() -> CGPoint { var a:CGFloat=0; return direction(&a) }
    func direction(inout len: CGFloat) -> CGPoint { len = length(); return (len < CGFloat(1e-20)) ? self : self / len }
    func rot90() -> CGPoint { return CGPoint(x: -y, y: x) }
    func sumabs() -> CGFloat { return fabs(x) + fabs(y) }
    func sumxy() -> CGFloat { return x + y }
    func flipY() -> CGPoint { return CGPoint(x: x,y: -y) }
    func doubleDot(v:CGPoint) -> CGPoint { return CGPoint(x: dot(v), y: dot(v.rot90())) }
    func rotateTo(dir:CGPoint) -> CGPoint { return doubleDot(dir.flipY()) }
    func rotate(theta: CGFloat) -> CGPoint { return rotateTo(trig(theta)) }
}

func trig(theta:CGFloat) -> CGPoint { return CGPoint(x: cos(theta), y: sin(theta)) }


func + (u: CGPoint, v: CGPoint) -> CGPoint { return CGPoint(x: u.x + v.x, y: u.y + v.y) }
func - (u: CGPoint, v: CGPoint) -> CGPoint { return CGPoint(x: u.x - v.x, y: u.y - v.y) }
func * (u: CGPoint, v: CGPoint) -> CGPoint { return CGPoint(x: u.x * v.x, y: u.y * v.y) }
func * (u: CGPoint, a: CGFloat) -> CGPoint { return CGPoint(x: u.x * a, y: u.y * a) }
func / (u: CGPoint, a: CGFloat) -> CGPoint { return CGPoint(x: u.x / a, y: u.y / a) }
func += (inout u: CGPoint, v: CGPoint) { u.x += v.x; u.y += v.y }
func -= (inout u: CGPoint, v: CGPoint) { u.x -= v.x; u.y -= v.y }
func *= (inout u: CGPoint, v: CGPoint) { u.x *= v.x; u.y *= v.y }
func *= (inout u: CGPoint, a: CGFloat) { u.x *= a; u.y *= a }
func /= (inout u: CGPoint, a: CGFloat) { u.x /= a; u.y /= a }
prefix func -(inout u: CGPoint) -> CGPoint { return CGPoint(x: -u.x,y: -u.y); }



