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
    var includeHooligan = BinaryToggle(current: false, text: "Include Hooligan?" )
    var includeOmnibus = BinaryToggle(current: false, text: "Include Omnibus?" )
    var allowBreakingTrumps = BinaryToggle(current: true, text: "Allow Breaking Trumps?" )
    var speedOfToss = ListToggle(list: ["Very Slow","Slow","Normal","Fast","Very Fast"], current: 3, text: "Speed of Tossed Cards" )
    var gameWinningScore = ListToggle(list:  ["50", "100", "150", "200", "250", "300", "500"],  current: 2, text: "Game Finishing Score" )
    var ruleSet = ListToggle(list: ["Spades","Hearts","Jacks"],  current: 1, text: "Rule Set" )
   
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
        self.gameWinningScore.current = GameSettings.sharedInstance.gameWinningScoreIndex
        self.ruleSet.current = GameSettings.sharedInstance.ruleSet
        self.allowBreakingTrumps.current = GameSettings.sharedInstance.allowBreakingTrumps
        self.includeHooligan.current = GameSettings.sharedInstance.includeHooligan
        self.includeOmnibus.current = GameSettings.sharedInstance.includeOmnibus
        
        }
    
    override func onExit()
    {
        if GameSettings.sharedInstance.changeSettings(
            noOfSuites.current,
            noOfPlayersAtTable: noOfPlayers.current,
            noOfCardsInASuite: noOfCardsInASuite.current,
            hasTrumps: hasTrumps.current,
            hasJokers: hasJokers.current,
            willPassCards:willPassCards.current,
            speedOfToss:speedOfToss.current,
            gameWinningScoreIndex:gameWinningScore.current,
            ruleSet:ruleSet.current,
            allowBreakingTrumps:allowBreakingTrumps.current,
            includeHooligan:includeHooligan.current,
            includeOmnibus:includeOmnibus.current
            )
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
        
        userInteractionEnabled = true
        
        name = "Option Background"

        
        optionSettings = [self.noOfSuites, noOfCardsInASuite, noOfPlayers, hasJokers, hasTrumps, willPassCards, gameWinningScore,speedOfToss, ruleSet, includeHooligan, includeOmnibus, allowBreakingTrumps]
        
        settupButtons()
        newPage()
        
    }

    func newPage()
    {
        let scene = gameScene!
        let midWidth = CGRectGetMidX(gameScene!.frame)
        
        for optionSetting in optionSettings
        {
            
        if(optionSetting.parent != nil)
           {
           optionSetting.removeFromParent()
           }
        }
        if (settingStart < optionSettings.count)
        {
        optionSettings[settingStart].name = "Setting1"
        optionSettings[settingStart].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.77 : 0.7))
        self.addChild(optionSettings[settingStart])
        }
        
        if (settingStart+1 < optionSettings.count)
        {
        optionSettings[settingStart+1].name = "Setting2"
        optionSettings[settingStart+1].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.62 : 0.5))
        self.addChild(optionSettings[settingStart+1])
        }
        
        if (settingStart+2 < optionSettings.count)
        {
        optionSettings[settingStart+2].name = "Setting3"
        optionSettings[settingStart+2].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.47 : 0.3))
        self.addChild(optionSettings[settingStart+2])
        }
 
        
        if(isBigDevice)
        {

        if (settingStart+3 < optionSettings.count)
            {
            optionSettings[settingStart+3].name = "Setting4"
            optionSettings[settingStart+3].position = CGPoint(x:midWidth,y:scene.frame.height *  0.32)
            self.addChild(optionSettings[settingStart+3])
            }
            
        if (settingStart+4 < optionSettings.count)
            {
            optionSettings[settingStart+4].name = "Setting5"
            optionSettings[settingStart+4].position = CGPoint(x:midWidth,y:scene.frame.height *  0.17)
            self.addChild(optionSettings[settingStart+4])
            }
            
        
        }
        
        let nextStart = settingStart +  noOfSettings
        
        moreButton.alpha = nextStart >= optionSettings.count ? 0.0 : 1.0
        backButton.alpha = settingStart == 0 ? 0.0 : 1.0
    }
    
    func settupButtons()
    {
        
        moreButton.setScale(ButtonSize.Small.scale)
        moreButton.anchorPoint = CGPoint(x: 1.0, y: 0.0)
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
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches )
        {
            let positionInScene = touch.locationInNode(self)
            
            if buttonTouched(positionInScene) { return }
         //   if cardTouched(positionInScene) { return }
        }
    }
}

