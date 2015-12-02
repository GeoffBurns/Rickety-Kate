//
//  OptionScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


/// Game Option Setting Screen
class OptionScreen: MultiPagePopup {
    var isSetup = false
    var noOfSuites = NumberRangeToggle(min: 3, max: 8, current: 6, text: "Number_Of_Suites".localize)
    var noOfCardsInASuite = NumberRangeToggle(min: 10, max: 18, current: 14, text: "Number_In_Suite".localize)
    var noOfPlayers = NumberRangeToggle(min: 3, max:(GameSettings.isPad ? 7 : 6), current: 4, text: "Number_Of_Players".localize)
    
    var hasJokers = BinaryToggle(current: false, text: "Include_Jokers".localize)
    var hasTrumps = BinaryToggle(current: false, text: "Include_Tarot_Trumps".localize)
    var willPassCards = BinaryToggle(current: false, text: "Pass_Worst_Cards".localize)
    var includeHooligan = BinaryToggle(current: false, text: "Include_Hooligan".localize)
    var includeOmnibus = BinaryToggle(current: false, text: "Include_Omnibus".localize)
    var allowBreakingTrumps = BinaryToggle(current: true, text: "Allow_Breaking_Trumps".localize)
    var useNumbersForCourtCards = BinaryToggle(current: false, text: "Use Numbers For Court Cards".localize)
    var speedOfToss = ListToggle(list: ["Very Slow".localize,
        "Slow".localize,
        "Normal".localize,
        "Fast".localize,
        "Very Fast".localize
        ], current: 3, text: "Speed_Of_Cards".localize)
    var gameWinningScore = ListToggle(list:  ["50", "100", "150", "200", "250", "300", "500"],  current: 2, text: "Game_Finishing_Score".localize)
    var ruleSet = ListToggle(list: ["Spades".localize,"Hearts".localize,"Jacks".localize],  current: 1, text: "Rule Set".localize )
 


 
    var optionSettings = [SKNode]()
    let isBigDevice = GameSettings.isBigDevice
    var noOfItemsOnPage : Int { return isBigDevice ? 5 : 3 }
    var separationOfItems :  Float { return isBigDevice ? 0.15 : 0.2 }
    var startHeight :  Float { return isBigDevice ? 0.77 : 0.7 }

    
    var noOfSettings : Int { return GameSettings.isBigDevice ? 5 : 3 }

    
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
        self.useNumbersForCourtCards.current = GameSettings.sharedInstance.useNumbersForCourtCards
        }
    
    override func exit()
    {
        onExit()
        removeFromParent()
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
            includeOmnibus:includeOmnibus.current,
            useNumbersForCourtCards:useNumbersForCourtCards.current
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
        pageNo = 0
        
        optionSettings = [self.noOfSuites, noOfCardsInASuite, noOfPlayers, hasJokers, hasTrumps, willPassCards, gameWinningScore,speedOfToss, ruleSet, includeHooligan, includeOmnibus, allowBreakingTrumps,useNumbersForCourtCards]
            displayButtons()
        
        newPage()
    }
    override func noPageFor(tab:Int) -> Int
    {
        return optionSettings.count / noOfSettings + (optionSettings.count % noOfSettings == 0 ? 0 : 1)
    }
    
    override func newPage()
    {
        
        let settingStart = noOfSettings*self.pageNo
        let optionSettingsDisplayed = optionSettings
            .from(settingStart, forLength: noOfSettings)
      
        
        let startpos : CGFloat = GameSettings.isBigDevice ? 0.77 : 0.7
        let seperation : CGFloat =  GameSettings.isBigDevice ? 0.15 : 0.2
        
        let scene = gameScene!
        let midWidth = CGRectGetMidX(gameScene!.frame)
        
        for optionSetting in optionSettings
        {
            if(optionSetting.parent != nil)
            {
                optionSetting.removeFromParent()
            }
        }
        
        for (i, optionSetting) in optionSettingsDisplayed.enumerate()
        {
            optionSetting.name = "Setting" + (i + 1).description
            optionSetting.position = CGPoint(x:midWidth,y:scene.frame.height * (startpos - seperation * CGFloat(i)))
            self.addChild(optionSetting)
        }
    }

    }
    
 