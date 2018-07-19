//
//  StatusArea.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveSwift

protocol Resizable : class
{
     var adHeight : CGFloat { get }
     func arrangeLayoutFor(_ size:CGSize, bannerHeight:CGFloat)
}
// Tells the game player what is going on
class StatusDisplay : Resizable
{
    var adHeight = CGFloat(0.0)
    var noticeLabel2 = Label(fontNamed:"Chalkduster")
    var noticeLabel = Label(fontNamed:"Chalkduster")
 
    static let sharedInstance = StatusDisplay()
    fileprivate init() { }
    
    static func register(_ scene: SKNode)
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
    func arrangeLayoutFor(_ size:CGSize, bannerHeight:CGFloat)
    {
        let fontsize : CGFloat = FontSize.huge.scale
        adHeight = bannerHeight
        noticeLabel.position = CGPoint(x:size.width * 0.5, y:size.height * 0.33 + bannerHeight);
    
        noticeLabel2.position = CGPoint(x:size.width * 0.5, y:size.height * 0.68 + bannerHeight);
        
        
        noticeLabel.fontSize = fontsize;
        
        noticeLabel2.fontSize = fontsize;
    }
    func setupStatusArea(_ scene: SKNode)
    {
    noticeLabel2 = Game.settings.showTips
            ? Label(fontNamed:"Chalkduster").withShadow().withFadeOut()
            : Label(fontNamed:"Chalkduster").withShadow().withFadeInOut()
        
    noticeLabel = Game.settings.showTips
            ? Label(fontNamed:"Chalkduster").withShadow().withFadeOutAndAction
                {  Bus.sharedInstance.send(GameEvent.showTip(Tip.dispenceTip())) }
            : Label(fontNamed:"Chalkduster").withShadow().withFadeInOut()
    noticeLabel.resetToScene(scene)
    noticeLabel2.resetToScene(scene)
    arrangeLayoutFor(scene.frame.size,bannerHeight: 0.0)

    noticeLabel.rac_text <~ Bus.sharedInstance.gameSignal
        . filter { $0.description != nil }
        . map { $0.line2! }
       
        
    noticeLabel2.rac_text <~ Bus.sharedInstance.gameSignal
            . filter { $0.description != nil }
            . map { $0.line1! }
        
     
    }

}
