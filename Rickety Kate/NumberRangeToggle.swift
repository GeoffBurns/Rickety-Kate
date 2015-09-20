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
    var current = 1
    var text = ""
    
    var label = SKLabelNode(fontNamed:"Chalkduster")
    
    
    init(min:Int, max:Int, current:Int)
    {
     label.fontSize = 40;
        super.init()
    self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func touchDown()
    {
        current++
        if(current > max)
        {
           current = min
        }
        label.text = "\(text) : \(current)"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */

        for touch in (touches )
        {
            
      //  let touchPoint = touch.locationInNode(self.parent!)
      //  if self.containsPoint(touchPoint) {
            let touchPoint = touch.locationInNode(self)
                                        if label.containsPoint(touchPoint) {
    
            touchDown()
            return
        }
    }

   

    }}