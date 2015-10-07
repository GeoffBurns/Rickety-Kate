//
//  StatusArea.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

// Tells the game player what is going on
class StatusDisplay
{
    var noticeLabel = LabelWithFadeInAndOut(fontNamed:"Chalkduster")
    var noticeLabel2 = LabelWithFadeInAndOut(fontNamed:"Chalkduster")
 
    static let sharedInstance = StatusDisplay()
    private init() { }
    
    static func register(scene: SKNode)
    {
        StatusDisplay.sharedInstance.setupStatusArea(scene)
    }
    func setupStatusArea(scene: SKNode)
    {
    let fontsize : CGFloat = GameSettings.isPad ?  55 : (GameSettings.isPhone6Plus ? 90 : 65)
    if noticeLabel.parent != nil
      {
        noticeLabel.removeFromParent()
      }
    
    if noticeLabel2.parent != nil
      {
        noticeLabel2.removeFromParent()
      }
    noticeLabel.text = ""
    noticeLabel.fontSize = fontsize;
    noticeLabel.position = CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.33);
    
    noticeLabel2.fontSize = fontsize;
    noticeLabel2.position = CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.68);
    scene.addChild(noticeLabel)
    scene.addChild(noticeLabel2)
    
    Bus.sharedInstance.gameSignal.observeNext { gameEvent in
        
        let message = gameEvent.description
        if message == ""
        {
            self.noticeLabel.text = ""
            self.noticeLabel2.text = ""
            return
        }
        let messageLines = message.componentsSeparatedByString("\n")
        switch (messageLines.count)
        {
        case 1 :
            self.noticeLabel.text = message;
            self.noticeLabel2.text = "";
            
        default :
            self.noticeLabel2.text = messageLines[0];
            self.noticeLabel.text = messageLines[1];

        }
    }
    

}

}