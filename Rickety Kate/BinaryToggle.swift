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
    
    
    var current : Bool {didSet {updateLabelText()}}
    var text:String {didSet {updateLabelText()}}
    
    var label = SKLabelNode(fontNamed:"Chalkduster")
    var YorN : String { return current ? "Yes".localize : "No".localize }
    
    
    init(current:Bool, text: String)
    {
        self.current = current
        label.fontSize =  FontSize.big.scale
        self.text = text
        label.isUserInteractionEnabled = false
        
        super.init()
        updateLabelText()
        self.addChild(label)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateLabelText()
    {
        label.text = "\(text) : \(self.YorN)"
    }
    func touched()
    {
        current  = !current
        updateLabelText()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches )
        {
            let touchPoint = touch.location(in: self)
            
            if label.contains(touchPoint) {
                
                touched()
                return
            }
        }
        
    }}
