//
//  NumberRangeToggle.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


import SpriteKit

/// User input control for integers
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
        
    /// This works on simulator but not on device
    /*
    down.yScale = -0.15
    down.anchorPoint = CGPoint(x: 1.0, y: 1.0)
    */
    /// This works on simulator AND on device
    down.yScale = 0.15
    down.anchorPoint = CGPoint(x: 0.0, y: 1.0)
    down.zRotation = 180.degreesToRadians
    ////
        
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


/// User input control for integers
class ListToggle: SKNode {
    var list = [String]()
    var current : Int {didSet {update()}}
    var text:String {didSet {update()}}
    
    var label = SKLabelNode(fontNamed:"Chalkduster")
    var index : Int {
        var result = current - 1
        if result < 0 { result = 0 }
        if result > list.count - 1 { result = list.count - 1 }
        return result
    }
    
    init(list:[String], current: Int, text: String)
    {
        self.list = list
        self.current = current
        label.fontSize = 45;
        self.text = text
        label.userInteractionEnabled = false

        super.init()
        
        label.text = "\(text) : \(list[index])"
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
        
        /// This works on simulator but not on device
        /*
        down.yScale = -0.15
        down.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        */
        /// This works on simulator AND on device
        down.yScale = 0.15
        down.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        down.zRotation = 180.degreesToRadians
        ////
        
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
        label.text = "\(text) : \(list[index])"
    }
    func touchDown()
    {
        current--
        if(current < 0)
        {
            current = list.count
        }
        update()
    }
    func touchUp()
    {
        current++
        if(current > list.count)
        {
            current = 1
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