//
//  OptionScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


class OptionScreen: Popup {
    var noOfSuites = NumberRangeToggle(min: 3, max: 6, current: 4, text: "Number Of Suites in Deck")
    var isShowing = false
    var original = 4
    
    
    
    init(noOfSuites:Int)
    {
        original = noOfSuites
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
            if original != noOfSuites.current
            {
             gameScene!.noOfSuitesInDeck = self.noOfSuites.current
             gameScene!.resetWith(CardTable.makeDemo(self.noOfSuites.current))
            }
            
        }
        else
        {
            button.texture = SKTexture(imageNamed: "Options2")
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
        self.addChild(noOfSuites)
        alpha = 0.0
     
        
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

