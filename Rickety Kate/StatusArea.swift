//
//  StatusArea.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveCocoa


protocol Resizable : class
{
      func arrangeLayoutFor(size:CGSize)
}
// Tells the game player what is going on
class StatusDisplay : Resizable
{
    var noticeLabel2 = Label(fontNamed:"Chalkduster").withShadow().withFadeInOut()
    var noticeLabel = Label(fontNamed:"Chalkduster").withShadow().withFadeOutAndAction
        {  Bus.sharedInstance.send(GameEvent.ShowTip(Tip.dispenceTip())) }
 
    static let sharedInstance = StatusDisplay()
    private init() { }
    
    static func register(scene: SKNode)
    {
        StatusDisplay.sharedInstance.setupStatusArea(scene)
    }
    
    func setDemoMode()
    {
        Tip.tips = Tip.demoTips
        noticeLabel.displayTime = 4
        noticeLabel2.displayTime = 4
    }
    func setGameMode()
    {
        Tip.tips = Tip.gameTips
        noticeLabel.displayTime = 6
        noticeLabel2.displayTime = 6
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
        . map { $0.line2! }
       
        
    noticeLabel2.rac_text <~ Bus.sharedInstance.gameSignal
            . filter { $0.description != nil }
            . map { $0.line1! }
        
     
    }

}