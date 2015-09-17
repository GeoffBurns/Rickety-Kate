//
//  StatusArea.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Nereids Gold. All rights reserved.
//

import Foundation
import SpriteKit


class StatusDisplay
{
    var noticeLabel = SKLabelNode(fontNamed:"Chalkduster")
    var noticeLabel2 = SKLabelNode(fontNamed:"Chalkduster")
    var statusInfo = Publink<(String,String)>()
    
    static let sharedInstance = StatusDisplay()
    private init() { }
    
    static func publish(message1:String = "",message2:String = "")
    {
        StatusDisplay.sharedInstance.statusInfo.publish((message1,message2))
    }
    
    static func register(scene: SKNode)
    {
        StatusDisplay.sharedInstance.setupStatusArea(scene)
    }
    func setupStatusArea(scene: SKNode)
{
    
    if noticeLabel.parent != nil
    {
        noticeLabel.removeFromParent()
    }
    
    if noticeLabel2.parent != nil
    {
        noticeLabel2.removeFromParent()
    }
    noticeLabel.text = ""
    noticeLabel.fontSize = 65;
    noticeLabel.position = CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.4);
    
    noticeLabel2.fontSize = 65;
    noticeLabel2.position = CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.68);
    scene.addChild(noticeLabel)
    scene.addChild(noticeLabel2)
    
    statusInfo.subscribe() { (message1: String,message2: String) in
        
        self.noticeLabel.removeAllActions()
        self.noticeLabel2.removeAllActions()
        
        self.noticeLabel.alpha = 1.0
        self.noticeLabel2.alpha = 1.0
        
        let action = SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.fadeOutWithDuration(6),
                SKAction.waitForDuration(10),
                SKAction.fadeInWithDuration(4),
                SKAction.waitForDuration(5),
                ] )
        )
        switch (message1,message2)
        {
        case ("","") :
            self.noticeLabel.text = "";
            self.noticeLabel2.text = "";
        case (_,"") :
            self.noticeLabel.text = message1;
            self.noticeLabel2.text = "";
            self.noticeLabel.runAction(action)
            
        default :
            self.noticeLabel2.text = message1;
            self.noticeLabel.text = message2;
            self.noticeLabel.runAction(action)
            self.noticeLabel2.runAction(action)
        }
    }
    

}

}