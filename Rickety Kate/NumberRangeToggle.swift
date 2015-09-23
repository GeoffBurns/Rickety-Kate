//
//  NumberRangeToggle.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


import SpriteKit

/// TODO add up and down arrows
class NumberRangeToggle: SKNode {
    var min = 1
    var max = 10
    var current : Int {didSet {update()}}
    var text:String {didSet {update()}}
    
    var label = SKLabelNode(fontNamed:"Chalkduster")
    
    
    init(min:Int, max:Int, current:Int, text: String)
    {
    self.min = min
    self.max = max
    self.current = current
    label.fontSize = 45;
    self.text = text
    label.userInteractionEnabled = false
    label.text = "\(text) : \(current)"
    super.init()
        
    let height = label.frame.size.height
    let width = label.frame.size.width
    let up =   SKSpriteNode(imageNamed:"triangle")
    up.xScale = 0.35
    up.yScale = 0.15
    up.anchorPoint = CGPoint(x: 1.0, y: 0.0)
    up.position = CGPoint(x:width*0.5,y:height*0.6)
    label.addChild(up)
        
    let down =   SKSpriteNode(imageNamed:"triangle")
    down.name = "down"
    down.xScale = 0.35
    down.yScale = -0.15
    down.anchorPoint = CGPoint(x: 1.0, y: 1.0)
    down.position = CGPoint(x:width*0.5,y:-height*0.55)
    label.addChild(down)

    self.addChild(label)
    self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update()
    {
        label.text = "\(text) : \(current)"
    }
    func touchDown()
    {
        current--
        if(current < min)
        {
           current = max
        }
        update()
    }
    func touchUp()
    {
        current++
        if(current > max)
        {
            current = min
        }
        update()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */

        for touch in (touches )
        {
            let touchPoint = touch.locationInNode(self)
            if let touchedNode : SKSpriteNode = self.nodeAtPoint(touchPoint) as? SKSpriteNode
            where touchedNode.name == "down"
            {
                touchDown()
                return
            }
            
            
             if label.containsPoint(touchPoint) {
    
            touchUp()
            return
        }
    }

   

    }}