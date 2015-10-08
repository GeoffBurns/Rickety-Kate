//
//  StatusArea.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveCocoa

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
    noticeLabel.resetToScene(scene)
    noticeLabel2.resetToScene(scene)
    noticeLabel.fontSize = fontsize;
    noticeLabel.position = CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.33);
    
    noticeLabel2.fontSize = fontsize;
    noticeLabel2.position = CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.68);
   

    noticeLabel.rac_text <~ Bus.sharedInstance.gameSignal
        . filter { $0.description != nil }
        . map {
                gameEvent in
                let message = gameEvent.description!
                if message == ""
                  {
                    return ""
                  }
                let messageLines = message.componentsSeparatedByString("\n")
                switch (messageLines.count)
                {
                case 1 :
                    return message
                default :
                    return messageLines[1]
                }
        }
        noticeLabel2.rac_text <~ Bus.sharedInstance.gameSignal
            . filter { $0.description != nil }
            . map {
                gameEvent in
                let message = gameEvent.description!
                if message == ""
                {
                    return ""
                }
                let messageLines = message.componentsSeparatedByString("\n")
                switch (messageLines.count)
                {
                case 1 :
                    return ""
                default :
                    return messageLines[0]
                }
        }
     
    }

}