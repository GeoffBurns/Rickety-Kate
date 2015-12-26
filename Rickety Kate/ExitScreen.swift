//
//  ExitScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit



/// Are you sure screen
class ExitScreen: Popup, Resizable {
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
    
    override func setup(scene:SKNode)
    {
        button!.zPosition = 350
        let fontsize = FontSize.Huge.scale
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPointZero
        anchorPoint = CGPointZero
        name = "ExitBackground"
        userInteractionEnabled = true
        
        let midWidth = CGRectGetMidX(scene.frame)
        
        exitLabel.text = "Are you sure".localize
        exitLabel.fontSize = fontsize;
        exitLabel.position = CGPoint(x:midWidth, y:self.frame.size.height * 0.7);
        
        self.addChild(exitLabel)
        
        
        exitLabel2.text = "you_want_to_exit".localize
        exitLabel2.fontSize = fontsize;
        exitLabel2.position = CGPoint(x:midWidth, y:self.frame.size.height * 0.57);
        
        self.addChild(exitLabel2)
        

        yesButton.position = CGPoint(x:self.frame.width * 0.25,y:self.frame.height * 0.4)
        yesButton.setScale(ButtonSize.Small.scale)
        yesButton.zPosition = 100
        yesButton.name = "Yes"
        yesButton.userInteractionEnabled = false
        
        
        

        noButton.position = CGPoint(x:self.frame.width*0.75,y:self.frame.height * 0.4)
        noButton.setScale(ButtonSize.Small.scale)
        noButton.zPosition = 100
        noButton.name = "No"
        noButton.userInteractionEnabled = false
        
        self.addChild(yesButton)
        self.addChild(noButton)
    }
    
    func arrangeLayoutFor(size:CGSize)
    {

        noButton.position = CGPoint(x:size.width*0.75,y:size.height * 0.4)
        
        yesButton.position = CGPoint(x:size.width * 0.25,y:size.height * 0.4)
    
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