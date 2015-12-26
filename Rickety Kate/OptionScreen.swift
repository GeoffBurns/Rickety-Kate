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
    var noOfPlayers = NumberRangeToggle(min: 3, max:(DeviceSettings.isPad ? 7 : 6), current: 4, text: "Number_Of_Players".localize)
    
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
    var noOfItemsOnPage = 3
    var separationOfItems =  CGFloat(0.2)
    var startHeight =  CGFloat(0.7)
    
    var tabNewPage = [ displayOptions, gameCentre ]
    
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
        
        optionSettings = [self.noOfSuites, noOfCardsInASuite, noOfPlayers, hasJokers, hasTrumps, willPassCards, gameWinningScore,speedOfToss, ruleSet, includeHooligan, includeOmnibus, allowBreakingTrumps , useNumbersForCourtCards
        ]
        
        tabNames = ["Options","Gamecentre"]
        
        arrangeLayoutFor(size)
    }
    
    override func noPageFor(tab:Int) -> Int
    {
        switch tab
        {
        case 0:
            return optionSettings.numOfPagesOf(noOfItemsOnPage)
        default :
            return 1
            
        }
    }
    
    override func arrangeLayoutFor(size:CGSize)
    {
        
        
        if DeviceSettings.isBigDevice
        {
            if DeviceSettings.isPortrait
            {
                
                noOfItemsOnPage = 7
                separationOfItems =  CGFloat(0.12)
                startHeight = CGFloat(0.87)
            }
            else
            {
                
                noOfItemsOnPage = 5
                separationOfItems =  CGFloat(0.15)
                startHeight = CGFloat(0.77)
            }
        }
        else
        {
            noOfItemsOnPage = 3
            separationOfItems =  CGFloat(0.2)
            startHeight = CGFloat(0.7)
        }
        
        super.arrangeLayoutFor(size)
        if pageNo > noPageFor(tabNo) - 1
        {
            pageNo = noPageFor(tabNo) - 1
        }
        super.arrangeLayoutFor(size)
        displayButtons()
        newPage()
    }
    
    func gameCentre()
    {
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate ,
               controller = appDelegate.window?.rootViewController
        {
        GameKitHelper.sharedInstance.showGKGameCenterViewController(
            controller) { self.tabNo = 0; self.pageNo = 0 ; self.newPage()}
        }
    }
    
    override func newPage()
    {
        if self.tabNo < 0 { return }
        
        for optionSetting in optionSettings
        {
            if(optionSetting.parent != nil)
            {
                optionSetting.removeFromParent()
            }
        }
        
        
        let renderPage = self.tabNewPage[self.tabNo](self)
      
        renderPage()
      
    }
    func displayOptions()
    {
        
        let settingStart = noOfItemsOnPage*self.pageNo
        let optionSettingsDisplayed = optionSettings
            .from(settingStart, forLength: noOfItemsOnPage)
      
        let scene = gameScene!
        let midWidth = CGRectGetMidX(gameScene!.frame)
        
     
        for (i, optionSetting) in optionSettingsDisplayed.enumerate()
        {
            optionSetting.name = "Setting" + (i + 1).description
            optionSetting.position = CGPoint(x:midWidth,y:scene.frame.height * (startHeight - separationOfItems * CGFloat(i)))
            self.addChild(optionSetting)
        }
    }

    }
    
 