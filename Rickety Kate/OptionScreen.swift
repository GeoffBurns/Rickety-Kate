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
    
    var noOfSuites = NumberRangeToggle(min: 3, max: 8, current: 6, text: "Number_Of_Suites".localize)
    var noOfCardsInASuite = NumberRangeToggle(min: 10, max: 18, current: 14, text: "Number_In_Suite".localize)
    var noOfPlayers = NumberRangeToggle(min: 3, max:(GameSettings.isPad ? 7 : 6), current: 4, text: "Number_Of_Players".localize)
    
    var hasJokers = BinaryToggle(current: false, text: "Include_Jokers".localize)
    var hasTrumps = BinaryToggle(current: false, text: "Include_Tarot_Trumps".localize)
    var willPassCards = BinaryToggle(current: false, text: "Pass_Worst_Cards".localize)
    var includeHooligan = BinaryToggle(current: false, text: "Include_Hooligan".localize)
    var includeOmnibus = BinaryToggle(current: false, text: "Include_Omnibus".localize)
    var allowBreakingTrumps = BinaryToggle(current: true, text: "Allow_Breaking_Trumps".localize)
    var speedOfToss = ListToggle(list: ["Very Slow".localize,
        "Slow".localize,
        "Normal".localize,
        "Fast".localize,
        "Very Fast".localize
        ], current: 3, text: "Speed_Of_Cards".localize)
    var gameWinningScore = ListToggle(list:  ["50", "100", "150", "200", "250", "300", "500"],  current: 2, text: "Game_Finishing_Score".localize)
    var ruleSet = ListToggle(list: ["Spades".localize,"Hearts".localize,"Jacks".localize],  current: 1, text: "Rule Set".localize )
 


 
    var optionSettings = [SKNode]()
    var moreButton = SKSpriteNode(imageNamed: "More1".symbol)
    var backButton = SKSpriteNode(imageNamed: "Back".symbol)
    let isBigDevice = GameSettings.isBigDevice
    var noOfItemsOnPage : Int { return isBigDevice ? 5 : 3 }
    var separationOfItems :  Float { return isBigDevice ? 0.15 : 0.2 }
    var startHeight :  Float { return isBigDevice ? 0.77 : 0.7 }

    var pageStart = 0
    
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
            if let scene = gameScene as? RicketyKateGameScene
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
        if (pageStart < optionSettings.count)
        {
        optionSettings[pageStart].name = "Setting1"
        optionSettings[pageStart].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.77 : 0.7))
        self.addChild(optionSettings[pageStart])
        }
        
        if (pageStart+1 < optionSettings.count)
        {
        optionSettings[pageStart+1].name = "Setting2"
        optionSettings[pageStart+1].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.62 : 0.5))
        self.addChild(optionSettings[pageStart+1])
        }
        
        if (pageStart+2 < optionSettings.count)
        {
        optionSettings[pageStart+2].name = "Setting3"
        optionSettings[pageStart+2].position = CGPoint(x:midWidth,y:scene.frame.height * (isBigDevice ? 0.47 : 0.3))
        self.addChild(optionSettings[pageStart+2])
        }
 
        
        if(isBigDevice)
        {

        if (pageStart+3 < optionSettings.count)
            {
            optionSettings[pageStart+3].name = "Setting4"
            optionSettings[pageStart+3].position = CGPoint(x:midWidth,y:scene.frame.height *  0.32)
            self.addChild(optionSettings[pageStart+3])
            }
            
        if (pageStart+4 < optionSettings.count)
            {
            optionSettings[pageStart+4].name = "Setting5"
            optionSettings[pageStart+4].position = CGPoint(x:midWidth,y:scene.frame.height *  0.17)
            self.addChild(optionSettings[pageStart+4])
            }
            
        
        }
        
        let nextStart = pageStart +  noOfItemsOnPage
        
        moreButton.alpha = nextStart >= optionSettings.count ? 0.0 : 1.0
        backButton.alpha = pageStart == 0 ? 0.0 : 1.0
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
                self.pageStart += noOfItemsOnPage
                newPage()
                
                return true
            case "Back" :
                
                self.pageStart -= noOfItemsOnPage
                
                if self.pageStart < 0
                {
                    self.pageStart = 0
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
        }
    }
}

