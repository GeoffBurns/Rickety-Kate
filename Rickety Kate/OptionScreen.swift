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
    var noOfSuites = NumberRangeToggle(min: 3, max: 8, current: 6, text: "Number Of Suites".localize)
    var noOfCardsInASuite = NumberRangeToggle(min: 10, max: 18, current: 14, text: "Number In Suite".localize)
    var noOfPlayers = NumberRangeToggle(min: 3, max:(DeviceSettings.isPad ? 7 : 6), current: 4, text: "Number Of Players".localize)
    var noOfHumanPlayers = NumberRangeToggle(min: 1, max:(DeviceSettings.isPad ? 7 : 6), current: 1, text: "Number of Human Players".localize)
    var hasJokers = BinaryToggle(current: false, text: "Include Jokers".localize)
    var hasTrumps = BinaryToggle(current: false, text: "Include Tarot Trumps".localize)
    var willPassCards = BinaryToggle(current: false, text: "Pass Worst Cards".localize)
    var showTips = BinaryToggle(current: true, text: "Show Tips".localize)
    var includeHooligan = BinaryToggle(current: false, text: "Include Hooligan".localize)
    var includeOmnibus = BinaryToggle(current: false, text: "Include Omnibus".localize)
    var allowBreakingTrumps = BinaryToggle(current: true, text: "Allow Breaking Trumps".localize)
    var useNumbersForCourtCards = BinaryToggle(current: false, text: "Use Numbers For Court Cards".localize)
    var speedOfToss = ListToggle(list: ["Very Slow".localize,
        "Slow".localize,
        "Normal".localize,
        "Fast".localize,
        "Very Fast".localize
        ], current: 3, text: "Speed Of Cards".localize)
    var gameWinningScore = ListToggle(list:  ["50", "100", "150", "200", "250", "300", "500"],  current: 2, text: "Game Finishing Score".localize)
    var ruleSet = ListToggle(list: ["Spades".localize,"Hearts".localize,"Jacks".localize],  current: 1, text: "Rule Set".localize )
 
    var optionSettings = [SKNode]()
    var multiPlayerSettings = [SKNode]()
    var gameCenterSettings = [SKNode]()
    var noOfItemsOnPage = 3
    var separationOfItems =  CGFloat(0.2)
    var startHeight =  CGFloat(0.7)
    
//    var tabNewPage = [ displayOptions, gameCentre, displayMultiplayer ]
     var tabNewPage = [ displayOptions, gameCentre ]
    
    override func onEnter() {
        self.noOfSuites.current = Game.settings.noOfSuitesInDeck
        self.noOfPlayers.current = Game.settings.noOfPlayersAtTable
        self.noOfHumanPlayers.current = Game.settings.noOfHumanPlayers
        self.noOfCardsInASuite.current = Game.settings.noOfCardsInASuite
        self.hasTrumps.current = Game.settings.hasTrumps
        self.hasJokers.current = Game.settings.hasJokers
        self.willPassCards.current = Game.settings.willPassCards
        self.speedOfToss.current = Game.settings.speedOfToss
        self.gameWinningScore.current = Game.moreSettings.gameWinningScoreIndex
        self.ruleSet.current = Game.moreSettings.ruleSet
        self.allowBreakingTrumps.current = Game.moreSettings.allowBreakingTrumps
        self.includeHooligan.current = Game.moreSettings.includeHooligan
        self.includeOmnibus.current = Game.moreSettings.includeOmnibus
        self.useNumbersForCourtCards.current = Game.settings.useNumbersForCourtCards
        self.showTips.current = Game.settings.showTips
        }
    
    override func exit()
    {
        onExit()
        removeFromParent()
    }
    
    override func onExit()
    {
        if Game.moreSettings.changeSettings(
            noOfSuites.current,
            noOfPlayersAtTable: noOfPlayers.current,
            noOfCardsInASuite: noOfCardsInASuite.current,
            hasTrumps: hasTrumps.current,
            hasJokers: hasJokers.current,
            willPassCards: willPassCards.current,
            speedOfToss: speedOfToss.current,
            gameWinningScoreIndex: gameWinningScore.current,
            ruleSet: ruleSet.current,
            allowBreakingTrumps: allowBreakingTrumps.current,
            includeHooligan: includeHooligan.current,
            includeOmnibus: includeOmnibus.current,
            useNumbersForCourtCards: useNumbersForCourtCards.current,
            noOfHumanPlayers: noOfHumanPlayers.current,
            showTips:showTips.current

            )
        {
            if let scene = gameScene as? RicketyKateGameScene
            {
                scene.resetSceneAsDemo()
            }
        }
      super.onExit()
    }
    
    override func  setup(_ scene:SKNode)
    {
        
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        var layoutSize = size
        position = CGPoint.zero
        anchorPoint = CGPoint.zero
        
        isUserInteractionEnabled = true
        
        name = "Option Background"
        pageNo = 0
        
        optionSettings = [self.noOfSuites, noOfCardsInASuite, noOfPlayers, hasJokers, hasTrumps, willPassCards, gameWinningScore,speedOfToss, ruleSet, includeHooligan, includeOmnibus, showTips, allowBreakingTrumps , useNumbersForCourtCards
        ]
        multiPlayerSettings = [noOfHumanPlayers]
     //   tabNames = ["Options","Gamecentre","multiplayer"]
        tabNames = ["Options","Gamecentre"]
        if let resize = scene as? Resizable
        {
            self.adHeight = resize.adHeight
            layoutSize = CGSize(width: size.width, height: size.height - self.adHeight)
        }
        arrangeLayoutFor(layoutSize,bannerHeight: adHeight)
    }
    
    override func noPageFor(_ tab:Int) -> Int
    {
        switch tab
        {
        case 0:
            return optionSettings.numOfPagesOf(noOfItemsOnPage)
        default :
            return 1
        }
    }
    
    override func arrangeLayoutFor(_ size:CGSize,bannerHeight:CGFloat)
    {
        
        if DeviceSettings.isBigDevice {
            if DeviceSettings.isPortrait {
                if DeviceSettings.isPadPro
                {
                noOfItemsOnPage = 7
                separationOfItems =  CGFloat(0.12)
                startHeight = CGFloat(0.87)
                }
                else
                {
                    noOfItemsOnPage = 6
                    separationOfItems =  CGFloat(0.14)
                    startHeight = CGFloat(0.77)
                }
            } else {
                noOfItemsOnPage = 5
                separationOfItems =  CGFloat(0.15)
                startHeight = CGFloat(0.77)
            }
        } else {
            noOfItemsOnPage = 3
            separationOfItems =  CGFloat(0.2)
            startHeight = CGFloat(0.7)
        }
        
        super.arrangeLayoutFor(size,bannerHeight:bannerHeight)
        if pageNo > noPageFor(tabNo) - 1 {
            pageNo = noPageFor(tabNo) - 1
        }
        
        super.arrangeLayoutFor(size,bannerHeight:bannerHeight)
        displayButtons()
        newPage()
    }
    
    override func newPage()
    {
        if self.tabNo < 0 { return }
        for optionSetting in optionSettings {
            if optionSetting.parent != nil {
                optionSetting.removeFromParent()
            }
        }
        for multiplayerSetting in multiPlayerSettings {
            if multiplayerSetting.parent != nil {
                multiplayerSetting.removeFromParent()
            }
        }
        
        for gameCenterSetting in gameCenterSettings {
            if gameCenterSetting.parent != nil {
                gameCenterSetting.removeFromParent()
            }
        }
        let renderPage = self.tabNewPage[self.tabNo](self)
      
        renderPage()
    }
    /// Allow rule of the game to be changed
    func displayOptions()
    {
        let settingStart = noOfItemsOnPage*self.pageNo
        let optionSettingsDisplayed = optionSettings
            .from(settingStart, forLength: noOfItemsOnPage)
      
        let scene = gameScene!
        let midWidth = gameScene!.frame.midX
        
        for (i, optionSetting) in optionSettingsDisplayed.enumerated() {
            optionSetting.name = "Setting" + (i + 1).description
            optionSetting.position = CGPoint(x:midWidth,y:scene.frame.height * (startHeight - separationOfItems * CGFloat(i)))
            self.addChild(optionSetting)
        }
    }
    ///
    func gameCentre()
    {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate ,
            let controller = appDelegate.window?.rootViewController
        {
            GameKitHelper.sharedInstance.showGKGameCenterViewController(
                controller) { self.tabNo = 0; self.pageNo = 0 ; self.newPage()}
        }
        
        let fontsize : CGFloat = FontSize.small.scale
        let warn = SKLabelNode(fontNamed:"Verdana")
        warn.name = "Setting1"
        warn.fontSize = fontsize
        warn.position = CGPoint(x: size.width * 0.50, y: size.height * 0.50)
        warn.text = "Having trouble connecting to Game Center".localize
        gameCenterSettings = [warn]
        self.addChild(warn)
    }
    /// display pass the phone multiplayer mode settings
    func displayMultiplayer()
    {
        let settingStart = noOfItemsOnPage*self.pageNo
        let multiplayerSettingsDisplayed = multiPlayerSettings
            .from(settingStart, forLength: noOfItemsOnPage)
        
        let scene = gameScene!
        let midWidth = gameScene!.frame.midX
        
        for (i, multiplayerSetting) in multiplayerSettingsDisplayed.enumerated()
        {
            multiplayerSetting.name = "Setting" + (i + 1).description
            multiplayerSetting.position = CGPoint(x:midWidth,y:scene.frame.height * (startHeight - separationOfItems * CGFloat(i)))
            self.addChild(multiplayerSetting)
        }
    }

    }
    
 
