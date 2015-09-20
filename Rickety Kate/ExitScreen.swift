//
//  ExitScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

class Popup: SKSpriteNode {

    var gameScene : GameScene? = nil
    var button =  SKSpriteNode(imageNamed:"Exit")
    
    
    init()
    {
        super.init(texture: nil, color: UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9), size:  CGSize(width: 1, height: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExitScreen: Popup {
    var exitLabel = SKLabelNode(fontNamed:"Chalkduster")
    var exitLabel2 = SKLabelNode(fontNamed:"Chalkduster")
    var isShowing = false

    
    var label = SKLabelNode(fontNamed:"Chalkduster")
    
    
    override init()
    {
        label.fontSize = 40;
        super.init()
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(scene:GameScene)
    {
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPoint(x:CGRectGetMidX(scene.frame),y:CGRectGetMidY(scene.frame))
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        name = "ExitBackground"
        userInteractionEnabled = true
        zPosition = -10
        alpha = 0.0
        
        exitLabel.text = "Are you sure"
        exitLabel.fontSize = 65;
        exitLabel.position = CGPoint(x:self.frame.width * 0.0, y:self.frame.size.height * 0.2);
        
        self.addChild(exitLabel)
        
        
        exitLabel2.text = "you want to exit?"
        exitLabel2.fontSize = 65;
        exitLabel2.position = CGPoint(x:self.frame.width * 0.0, y:self.frame.size.height * 0.07);
        
        self.addChild(exitLabel2)
        
        let yesButton =  SKSpriteNode(imageNamed:"Yes")
        yesButton.position = CGPoint(x:self.frame.width * -0.25,y:self.frame.height * -0.1)
        yesButton.setScale(0.5)
        yesButton.zPosition = 100
        yesButton.name = "Yes"
        yesButton.userInteractionEnabled = false
        
        
        
        let noButton =  SKSpriteNode(imageNamed:"No")
        noButton.position = CGPoint(x:self.frame.width*0.25,y:self.frame.height * -0.1)
        noButton.setScale(0.5)
        noButton.zPosition = 100
        noButton.name = "No"
        noButton.userInteractionEnabled = false
        
        self.addChild(yesButton)
        self.addChild(noButton)
        
        scene.addChild(self)
        
        button.setScale(0.5)
        button.anchorPoint = CGPoint(x: 1.0,
            y:
            UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
                1.6 :
            2.2)
        button.position = CGPoint(x:self.frame.size.width,y:self.frame.size.height)
        
        button.name = "Exit"
        
        button.zPosition = 450
        button.userInteractionEnabled = false
        scene.addChild(button)
    }

    func isNodeAYesButton(node:SKSpriteNode) -> Bool
    {
        return node.name == "Yes"
    }
    func isNodeANoButton(node:SKSpriteNode) -> Bool
    {
        return node.name == "No"
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let width = self.frame.size.width
        let height = self.frame.size.height
        for touch in (touches )
        {
            let positionInScene = touch.locationInNode(self)
            
            //   var a = self.nodesAtPoint(positionInScene)
            if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode
            {

            if isNodeANoButton(touchedNode)
            {
                button.texture = SKTexture(imageNamed: "Exit")
                alpha = 0.0
                zPosition = -10
            }
            if isNodeAYesButton(touchedNode)
            {
                touchedNode.texture = SKTexture(imageNamed: "Yes2")
                gameScene!.reverseDeal(width , height: height )
                
                let doneAction2 =  (SKAction.sequence([SKAction.waitForDuration(gameScene!.cardTossDuration),
                    SKAction.runBlock({
                        let transition = SKTransition.crossFadeWithDuration(0.5)
                        let scene = GameScene(size: self.scene!.size)
                        scene.scaleMode = SKSceneScaleMode.AspectFill
                        scene.table = CardTable.makeDemo()
                        self.scene!.view!.presentScene(scene, transition: transition)
                        
                    })]))
                self.runAction(doneAction2)
            }

            }
        }
    }
}