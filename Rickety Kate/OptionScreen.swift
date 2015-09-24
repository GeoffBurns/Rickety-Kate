//
//  OptionScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


/// Game Option Setting Screen
class OptionScreen: Popup {
    var noOfSuites = NumberRangeToggle(min: 3, max: 6, current: 4, text: "Number Of Suites in Deck")
    var noOfCardsInASuite = NumberRangeToggle(min: 10, max: 15, current: 13, text: "Number Of Cards in Suite")
    var noOfPlayers = NumberRangeToggle(min: 3, max: 6, current: 4, text: "Number Of Players At Table")
    var isShowing = false

    
    override init()
    {
        super.init()
        button =  SKSpriteNode(imageNamed:"Options1")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipButton()
    {
        if(isShowing)
        {
   
            button.texture = SKTexture(imageNamed: "Options1")
            alpha = 0.0
            zPosition = -10
            button.zPosition = 300
            isShowing = false
            if GameSettings.changeSettings(noOfSuites.current,noOfPlayersAtTable: noOfPlayers.current,noOfCardsInASuite: noOfCardsInASuite.current)
            {
             gameScene!.resetWith(CardTable.makeDemo())
            }
            
        }
        else
        {
            button.texture = SKTexture(imageNamed: "X")
            alpha = 1.0
            zPosition = 400
            button.zPosition = 4450
            isShowing = true
        }
        
    }
    func  setup(scene:GameScene)
    {
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPoint(x:CGRectGetMidX(scene.frame),y:CGRectGetMidY(scene.frame))
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        name = "Option Background"
        zPosition = -10
        
        noOfSuites.name = "NoOfSuites"
        noOfSuites.alpha = 1.0
        noOfSuites.position = CGPoint(x:0.0,y:scene.frame.height * 0.2)

        self.addChild(noOfSuites)
        
        noOfPlayers.name = "NoOfPlayers"
        noOfPlayers.alpha = 1.0
        
        noOfPlayers.position = CGPoint(x:0.0,y:scene.frame.height * -0.2)
        self.addChild(noOfPlayers)
        alpha = 0.0
        
        
        noOfCardsInASuite.name = "NoOfCardsInSuite"
        noOfCardsInASuite.alpha = 1.0
        
        noOfCardsInASuite.position = CGPoint(x:0.0,y:scene.frame.height * -0.0)
        self.addChild(noOfCardsInASuite)
     
        
        button.setScale(0.5)
        button.anchorPoint = CGPoint(x: 1.0,
            y:
            UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
                1.6 :
            2.2)
        button.position = CGPoint(x:self.frame.size.width,y:self.frame.size.height)
        
        button.name = "Option"
        
        button.zPosition = 300
        button.userInteractionEnabled = false
        
        scene.addChild(button)
        scene.addChild(self)
        
    }
}

