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
    var noOfCardsInASuite = NumberRangeToggle(min: 10, max: 18, current: 13, text: "Number Of Cards in Suite")
    var noOfPlayers = NumberRangeToggle(min: 3, max:(GameSettings.isPad ? 7 : 6), current: 4, text: "Number Of Players At Table")
    var hasJokers = BinaryToggle(current: false, text: "Include Jokers?" )
    var hasTrumps = BinaryToggle(current: false, text: "Include Tarot Trumps?" )
    var willPassCards = BinaryToggle(current: true, text: "Pass Worst Cards?" )
    var speedOfToss = NumberRangeToggle(min: 1, max: 5, current: 3, text: "Speed of Tossed Cards" )
    var ruleSet = NumberRangeToggle(min: 1, max: 2, current: 1, text: "Rule Set" )
    
    var optionSettings = [SKNode]()
    var moreButton = SKSpriteNode(imageNamed: "More1")
    var backButton = SKSpriteNode(imageNamed: "Back")
    let isBigDevice = GameSettings.isPad || GameSettings.isPhone6Plus
    var noOfSettings : Int { return isBigDevice ? 5 : 3 }
    var settingStart = 0
    
    override func onEnter() {
        self.noOfSuites.current = GameSettings.sharedInstance.noOfSuitesInDeck
        self.noOfPlayers.current = GameSettings.sharedInstance.noOfPlayersAtTable
        self.noOfCardsInASuite.current = GameSettings.sharedInstance.noOfCardsInASuite
        self.hasTrumps.current = GameSettings.sharedInstance.hasTrumps
        self.hasJokers.current = GameSettings.sharedInstance.hasJokers
        self.willPassCards.current = GameSettings.sharedInstance.willPassCards
        self.speedOfToss.current = GameSettings.sharedInstance.speedOfToss
        self.ruleSet.current = GameSettings.sharedInstance.ruleSet
        
        optionSettings = [self.noOfSuites, noOfCardsInASuite, noOfPlayers, hasJokers, hasTrumps, willPassCards, speedOfToss,ruleSet]
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
 
        noOfSuites.position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.77 : 0.7))

        self.addChild(noOfSuites)
        
        
        
        noOfCardsInASuite.name = "NoOfCardsInSuite"
  
        
        noOfCardsInASuite.position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.62 : 0.5))
        self.addChild(noOfCardsInASuite)
        
        noOfPlayers.name = "NoOfPlayers"

        
        noOfPlayers.position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.47 : 0.3))
        self.addChild(noOfPlayers)
        
        if(isBigDevice)
        {
        hasTrumps.name = "hasTrumps"

        
        hasTrumps.position = CGPoint(x:midWidth,y:scene.frame.height *  0.32)
        self.addChild(hasTrumps)
            
        hasJokers.name = "hasJokers"
       
            
        hasJokers.position = CGPoint(x:midWidth,y:scene.frame.height *  0.17)
        self.addChild(hasJokers)
            
            
   
        }
        
    }
    func newPage()
    {
        let scene = gameScene!
        let midWidth = CGRectGetMidX(gameScene!.frame)
        
        optionSettings[settingStart].name = "Setting1"
        optionSettings[settingStart].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.77 : 0.7))
        self.addChild(optionSettings[settingStart])
        
        optionSettings[settingStart+1].name = "Setting2"
        optionSettings[settingStart+1].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.62 : 0.5))
        self.addChild(optionSettings[settingStart+1])
 
        optionSettings[settingStart+2].name = "Setting3"
        optionSettings[settingStart+2].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.47 : 0.3))
        self.addChild(optionSettings[settingStart+2])
        
        
        if(isBigDevice)
        {
            optionSettings[settingStart+3].name = "Setting4"
            optionSettings[settingStart+3].position = CGPoint(x:midWidth,y:scene.frame.height *  0.32)
            self.addChild(optionSettings[settingStart+3])
            
            optionSettings[settingStart+4].name = "Setting5"
            optionSettings[settingStart+4].position = CGPoint(x:midWidth,y:scene.frame.height *  0.17)
            self.addChild(optionSettings[settingStart+4])
        }
    }
    
    func settupButtons()
    {
        
        moreButton.setScale(ButtonSize.Small.scale)
        moreButton.anchorPoint = CGPoint(x: 2.0, y: 0.0)
        moreButton.position = CGPoint(x:self.frame.size.width,y:0.0)
        
        moreButton.name = "More"
        
        moreButton.zPosition = 300
        moreButton.userInteractionEnabled = false
        
        self.addChild(moreButton)
        
        backButton.setScale(ButtonSize.Small.scale)
        backButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        backButton.position = CGPoint(x:0.0,y:0.0)
        
        backButton.name = "Back"
        
        backButton.zPosition = 300
        backButton.userInteractionEnabled = false
        backButton.alpha = 0.0
        self.addChild(backButton)
        
    }
    func buttonTouched(positionInScene:CGPoint) -> Bool
    {
        if let touchedNode : SKSpriteNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode,
            nodeName =  touchedNode.name
        {
            switch nodeName
            {
            case "More" :
                self.settingStart += noOfSettings
                newPage()
                
                return true
            case "Back" :
                
                self.settingStart -= noOfSettings
                
                if self.settingStart < 0
                {
                    self.settingStart = 0
                }
                newPage()
                
                return true
            default:
                return false
                
            }
        }
        
        return false
    }

}

