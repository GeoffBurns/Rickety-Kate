//
//  NumberRangeToggle.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Nereids Gold. All rights reserved.
//


import SpriteKit

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
    label.fontSize = 40;
    self.text = text
        label.userInteractionEnabled = false
        label.text = "\(text) : \(current)"
    super.init()
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
                                        if label.containsPoint(touchPoint) {
    
            touchDown()
            return
        }
    }

   

    }}