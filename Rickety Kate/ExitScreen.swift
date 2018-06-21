//
//  ExitScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// Are you sure screen
class ExitScreen: Popup //, Resizable
{
    var exitLabel = SKLabelNode(fontNamed:"Chalkduster")
    var exitLabel2 = SKLabelNode(fontNamed:"Chalkduster")
    let yesButton =  SKSpriteNode(imageNamed:"Yes")
    let noButton =  SKSpriteNode(imageNamed:"No")
    var isSetup = false
    
    override init()
    {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup(_ scene:SKNode)
    {
        button!.zPosition = 350
        let fontsize = FontSize.huge.scale
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPoint.zero
        anchorPoint = CGPoint.zero
        name = "ExitBackground"
        isUserInteractionEnabled = true
        
        let midWidth = scene.frame.midX
        
        exitLabel.text = "Are you sure".localize
        exitLabel.fontSize = fontsize;
        exitLabel.position = CGPoint(x:midWidth, y:self.frame.size.height * 0.7);
        
        self.addChild(exitLabel)
        
        exitLabel2.text = "you want to exit".localize
        exitLabel2.fontSize = fontsize;
        exitLabel2.position = CGPoint(x:midWidth, y:self.frame.size.height * 0.57);
        
        self.addChild(exitLabel2)
        
        yesButton.position = CGPoint(x:self.frame.width * 0.25,y:self.frame.height * 0.4)
        yesButton.setScale(ButtonSize.small.scale)
        yesButton.zPosition = 100
        yesButton.name = "Yes"
        yesButton.isUserInteractionEnabled = false
        
        noButton.position = CGPoint(x:self.frame.width*0.75,y:self.frame.height * 0.4)
        noButton.setScale(ButtonSize.small.scale)
        noButton.zPosition = 100
        noButton.name = "No"
        noButton.isUserInteractionEnabled = false
        
        self.addChild(yesButton)
        self.addChild(noButton)
    }
/*
    func arrangeLayoutFor(size:CGSize, bannerHeight:CGFloat)
    {
        noButton.position = CGPoint(x:size.width*0.75,y:size.height * 0.4 + bannerHeight)
        yesButton.position = CGPoint(x:size.width * 0.25,y:size.height * 0.4 + bannerHeight)
        
        exitLabel.position = CGPoint(x:size.width * 0.5, y:self.frame.size.height * 0.7 + bannerHeight);
   
        exitLabel2.position = CGPoint(x:size.width * 0.5, y:self.frame.size.height * 0.57 + bannerHeight);
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */

        for touch in (touches )
        {
            let positionInScene = touch.location(in: self)

            if let touchedNode : SKSpriteNode = self.atPoint(positionInScene) as? SKSpriteNode
              {
              if touchedNode.name == "No"
                {
                button!.unpress()
                }
              if touchedNode.name == "Yes"
                {
                touchedNode.texture = SKTexture(imageNamed: "Yes2")
                
                if let scene = gameScene as? RicketyKateGameScene
                    {
                    scene.resetSceneAsDemo()
                    }
                button!.unpress()
                }
            }
        }
    }
}
