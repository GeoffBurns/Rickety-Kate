//
//  BinaryToggle.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 26/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


import SpriteKit

/// User input control for integers
class BinaryToggle: SKNode {


    var current : Bool {didSet {update()}}
    var text:String {didSet {update()}}
    
    var label = SKLabelNode(fontNamed:"Chalkduster")
    
    
    init(current:Bool, text: String)
    {
        self.current = current
        label.fontSize = FontSize.Big.scale
        self.text = text
        label.userInteractionEnabled = false
        let YorN = current ? "Yes" : "No"
        label.text = "\(text) : \( YorN )"
        super.init()
        

               self.addChild(label)
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update()
    {
        let YorN = current ? "Yes" : "No"
        label.text = "\(text) : \(YorN)"
    }
    func touched()
    {
        current  = !current
        update()
    }
       override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches )
        {
            let touchPoint = touch.locationInNode(self)
         
            if label.containsPoint(touchPoint) {
                
                touched()
                return
            }
        }
        
        
        
    }}
