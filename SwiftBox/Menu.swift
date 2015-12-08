//
//  Menu.swift
//  SwiftBox
//
//  Created by John Henckel on 8/3/15.
//  Copyright (c) 2015 John Henckel. All rights reserved.
//

import SpriteKit


// The menu is a tree of label nodes, child[0] of each is a shape node.
// and child[1] is a node with a list of descendants, 123

// Pretty good fonts (iosfonts.com)
// *ArialMT, **ChalkboardSE-Regular, *DevanagariSangamMN, *Kailasa, *Palatino-Roman, **Verdana, Zapfino
//"*Courier" // "*Chalkduster"
//

class Menu {
    
    static let font = "ChalkboardSE-Regular"
    static let fontSize = 20 as CGFloat
    
    static let width = Menu.fontSize * 4
    static let height = Menu.fontSize * 1.4
}

extension SKLabelNode {
    
    
    
    
    func prefix() -> String {
        let pair = text!.componentsSeparatedByString(":")
        if pair.count == 2 {
            return pair[0]
        }
        return text!
    }
    
    func addSubmenu() -> SKNode {
        let sub = SKNode()
        sub.hidden = true
        addChild(sub)
        return sub
    }
    

    func brighten(valx: Bool = true) {
        if let shape = children[1] as? SKShapeNode {
            shape.fillColor = valx ? UIColor.blueColor() : UIColor.blackColor()
            shape.strokeColor = valx ? UIColor.yellowColor() : UIColor.grayColor()
        }
    }
    
    func appendValue(value: String) {
        text = prefix() + ": " + value
    }
    
    // Set a label node hidden value, as well as child 0,1 (the font and shape)
    func setHide(val: Bool)
    {
        hidden = val
        if children.count > 0 {
            children[0].hidden = val
        }
        if children.count > 1 {
            children[1].hidden = val
        }
    }

    // Set a label node visible, and its children, its ancestors and each of their children
    func setLineageVisible() {
        setHide(false)
        if children.count == 3 {
            children[2].setSubmenuVisible()
        }

        var next = self.children[0]
        while let node = next.parent?.parent {
            node.setSubmenuVisible()
            next = node
        }
    }
}

/*
These extensions are so you can make menus. The root of the menu is a regular SKNode
dx,dy are optional, and (1,0) puts the children to the RIGHT side of the parent.
*/
extension SKNode {
    
    func add(name: String) -> SKLabelNode {
        let shapeNode = SKShapeNode(rect: CGRect(x: 0, y: 0,
            width: Menu.width, height: Menu.height), cornerRadius: Menu.fontSize/3)
        shapeNode.position = CGPoint(x: Menu.fontSize * -0.3, y: Menu.fontSize * -0.25)
        shapeNode.fillColor = UIColor.blackColor()
        let labelNode = SKLabelNode(fontNamed:Menu.font)
        labelNode.color = UIColor.whiteColor()
        labelNode.text = name as String
        labelNode.fontSize = Menu.fontSize
        labelNode.verticalAlignmentMode = .Bottom
        labelNode.horizontalAlignmentMode = .Left
        labelNode.position =
            CGPoint(x: Menu.width * 1.05, y: CGFloat(children.count) * Menu.height * -1.1)
        
        labelNode.addChild(shapeNode)
        addChild(labelNode)
        return labelNode
    }


    /*
        You can add whole menu tree in one call.  [a,b,[c,d,e],f,g]
    */
    func addList(nameList: [NSObject]) {
        for item in nameList {
            if let name = item as? String {
                add(name)
            }
            else if let list = item as? [NSObject] {
                if let label = children.last as? SKLabelNode {
                    label.addSubmenu().addList(list)
                }
            }
        }
    }
    
    
    // Hide the entire tree of nodes (and set labels.brighten = false)
    func setTreeHidden() {
        hidden = true
        for node in children {
            node.setTreeHidden()
            if let label = node as? SKLabelNode {
                label.brighten(false)
            }
        }
    }
    
    func setSubmenuVisible() {
        hidden = false
        for n in children {
            if let label = n as? SKLabelNode {
                label.setHide(false)
            }
        }
    }

    
}

