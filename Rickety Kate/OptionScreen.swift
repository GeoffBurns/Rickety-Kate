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
    var noOfSuites = NumberRangeToggle(min: 3, max: 7, current: 4, text: "Number Of Suites in Deck")
    var noOfCardsInASuite = NumberRangeToggle(min: 10, max: 16, current: 13, text: "Number Of Cards in Suite")
    var noOfPlayers = NumberRangeToggle(min: 3, max:(GameSettings.isPad ? 7 : 6), current: 4, text: "Number Of Players At Table")
    
    var hasJokers = BinaryToggle(current: false, text: "Include Jokers?" )
    
    var hasTrumps = BinaryToggle(current: false, text: "Include Tarot Trumps?" )

    

    
    override func onEnter() {
        self.noOfSuites.current = GameSettings.sharedInstance.noOfSuitesInDeck
        self.noOfPlayers.current = GameSettings.sharedInstance.noOfPlayersAtTable
        self.noOfCardsInASuite.current = GameSettings.sharedInstance.noOfCardsInASuite
        self.hasTrumps.current = GameSettings.sharedInstance.hasTrumps
        
        self.hasJokers.current = GameSettings.sharedInstance.hasJokers
    }
    
    override func onExit()
    {
        if GameSettings.changeSettings(noOfSuites.current,noOfPlayersAtTable: noOfPlayers.current,noOfCardsInASuite: noOfCardsInASuite.current, hasTrumps: hasTrumps.current,hasJokers: hasJokers.current)
        {
            if let scene = gameScene as? GameScene
            {
                scene.resetSceneAsDemo()
            }
        }
      super.onExit()
    }

    

    override func  setup(scene:SKNode)
    {
        
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPointZero
        anchorPoint = CGPointZero
        
        let midWidth = CGRectGetMidX(scene.frame)
        name = "Option Background"

        
        noOfSuites.name = "NoOfSuites"
 
        noOfSuites.position = CGPoint(x:midWidth,y:scene.frame.height * (GameSettings.isPad ? 0.77 : 0.7))

        self.addChild(noOfSuites)
        
        
        
        noOfCardsInASuite.name = "NoOfCardsInSuite"
  
        
        noOfCardsInASuite.position = CGPoint(x:midWidth,y:scene.frame.height * (GameSettings.isPad ? 0.62 : 0.5))
        self.addChild(noOfCardsInASuite)
        
        noOfPlayers.name = "NoOfPlayers"

        
        noOfPlayers.position = CGPoint(x:midWidth,y:scene.frame.height * (GameSettings.isPad ? 0.47 : 0.3))
        self.addChild(noOfPlayers)
        
        if(GameSettings.isPad)
        {
        hasTrumps.name = "hasTrumps"

        
        hasTrumps.position = CGPoint(x:midWidth,y:scene.frame.height *  0.32)
        self.addChild(hasTrumps)
            
        hasJokers.name = "hasJokers"
       
            
        hasJokers.position = CGPoint(x:midWidth,y:scene.frame.height *  0.17)
        self.addChild(hasJokers)
        }
        
    }
}

