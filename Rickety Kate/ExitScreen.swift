//
//  ExitScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit



/// Are you sure screen
class ExitScreen: Popup {
    var exitLabel = SKLabelNode(fontNamed:"Chalkduster")
    var exitLabel2 = SKLabelNode(fontNamed:"Chalkduster")
    var isSetup = false
    
    override init()
    {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func setup(scene:SKNode)
    {
        button!.zPosition = 350
  
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPointZero
        anchorPoint = CGPointZero
        name = "ExitBackground"
        userInteractionEnabled = true
  
        let midWidth = CGRectGetMidX(scene.frame)
        
        exitLabel.text = "Are you sure"
        exitLabel.fontSize = 65;
        exitLabel.position = CGPoint(x:midWidth, y:self.frame.size.height * 0.7);
        
        self.addChild(exitLabel)
        
        
        exitLabel2.text = "you want to exit?"
        exitLabel2.fontSize = 65;
        exitLabel2.position = CGPoint(x:midWidth, y:self.frame.size.height * 0.57);
        
        self.addChild(exitLabel2)
        
        let yesButton =  SKSpriteNode(imageNamed:"Yes")
        yesButton.position = CGPoint(x:self.frame.width * 0.25,y:self.frame.height * 0.4)
        yesButton.setScale(0.5)
        yesButton.zPosition = 100
        yesButton.name = "Yes"
        yesButton.userInteractionEnabled = false
        
        
        
        let noButton =  SKSpriteNode(imageNamed:"No")
        noButton.position = CGPoint(x:self.frame.width*0.75,y:self.frame.height * 0.4)
        noButton.setScale(0.5)
        noButton.zPosition = 100
        noButton.name = "No"
        noButton.userInteractionEnabled = false
        
        self.addChild(yesButton)
        self.addChild(noButton)
        

    }


    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */

        for touch in (touches )
        {
            let positionInScene = touch.locationInNode(self)

            if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode
            {

            if touchedNode.name == "No"
            {
                button!.unpress()
                
            }
            if touchedNode.name == "Yes"
            {
                touchedNode.texture = SKTexture(imageNamed: "Yes2")
                
                if let scene = gameScene as? GameScene
                {
                    scene.resetSceneAsDemo()
                }
                button!.unpress()
    
            }

            }
        }
    }
}