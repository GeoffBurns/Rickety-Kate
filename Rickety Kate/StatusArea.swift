//
//  StatusArea.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveCocoa


protocol Resizable
{
      func arrangeLayoutFor(size:CGSize)
}
// Tells the game player what is going on
class StatusDisplay : Resizable
{
    var noticeLabel = Label(fontNamed:"Chalkduster").withShadow().withFadeInOut()
    var noticeLabel2 = Label(fontNamed:"Chalkduster").withShadow().withFadeInOut()
 
    static let sharedInstance = StatusDisplay()
    private init() { }
    
    static func register(scene: SKNode)
    {
        StatusDisplay.sharedInstance.setupStatusArea(scene)
    }
    
    func arrangeLayoutFor(size:CGSize)
    {
        let fontsize : CGFloat = FontSize.Huge.scale
        noticeLabel.position = CGPoint(x:size.width * 0.5, y:size.height * 0.33);
    
        noticeLabel2.position = CGPoint(x:size.width * 0.5, y:size.height * 0.68);
        
        
        noticeLabel.fontSize = fontsize;
        
        noticeLabel2.fontSize = fontsize;
    }
    func setupStatusArea(scene: SKNode)
    {
    noticeLabel.resetToScene(scene)
    noticeLabel2.resetToScene(scene)
    arrangeLayoutFor(scene.frame.size)

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