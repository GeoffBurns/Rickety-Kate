//
//  GameSettingExtensions.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/7/18.
//  Copyright © 2018 Nereids Gold. All rights reserved.
//

import Foundation

public enum GameFlavor
{
    
    case hooligan
    case soccer
    case bussing
    case straight
    
}

public protocol IGameSettings : ICardGameSettings
{
    var allowBreakingTrumps  : Bool { get }
    var includeHooligan  : Bool { get }
    var includeOmnibus  : Bool { get }
    var ruleSet  : Int { get }
    var gameWinningScore  : Int { get  }
    var rules : IAwarder { get  }
    var gameWinningScoreIndex : Int { get }
    var gameType : String { get }
    var achievementForWin : Achievement  { get }
    func random()
    
    func changeSettings(
        _ noOfSuitesInDeck:Int,
        noOfPlayersAtTable:Int,
        noOfCardsInASuite:Int,
        hasTrumps:Bool,
        hasJokers:Bool,
        willPassCards:Bool,
        speedOfToss:Int,
        gameWinningScoreIndex:Int,
        ruleSet:Int,
        allowBreakingTrumps:Bool,
        includeHooligan:Bool,
        includeOmnibus:Bool,
        useNumbersForCourtCards:Bool,
        noOfHumanPlayers: Int,
        showTips:Bool
        ) -> Bool
}
enum MoreProperties : String
{
    case dontBreakTrumps = "dontBreakTrumps"
    case includeHooligan = "includeHooligan"
    case includeOmnibus = "includeOmnibus"
    case ruleSet = "ruleSet"
    case gameWinningScore = "gameWinningScore"

}

extension Game
{
    public static var moreSettings : IGameSettings { return settings as! IGameSettings}
    public static var rules : IAwarder { return moreSettings.rules }
    public static let winningScores : [Int] = [ 20 , 50, 100, 150, 200, 250, 300, 500, 600]
}



extension LiveGameSettings : IGameSettings
{


    var allowBreakingTrumps : Bool {
        
        get {
            return !UserDefaults.standard.bool(forKey: MoreProperties.dontBreakTrumps.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(!newValue, forKey: MoreProperties.dontBreakTrumps.rawValue)
        }
    }
    var includeHooligan : Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: MoreProperties.includeHooligan.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: MoreProperties.includeHooligan.rawValue)
        }
    }
    var includeOmnibus : Bool {
        
        get {
            let result = UserDefaults.standard.bool(forKey: MoreProperties.includeOmnibus.rawValue)
            return result && Game.deck.setOfSuitesInDeck.contains(PlayingCard.Suite.diamonds)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: MoreProperties.includeOmnibus.rawValue)
        }
    }
    
    var ruleSet : Int {
        get {
            let result = UserDefaults.standard.integer(forKey: MoreProperties.ruleSet.rawValue)
            if result == 0
            {
                return 1
            }
            return result
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: MoreProperties.ruleSet.rawValue)
            data = nil
        }
    }
    
    var achievementForWin : Achievement
    {
        return self.rules.AchievementForWin(gameFlavor)
    }
    
    var gameFlavor : GameFlavor
    {
        if includeHooligan  {
            if includeOmnibus { return .soccer }
            return .hooligan
        }
        
        if includeOmnibus { return .bussing }
        return .straight
    }
    
    var gameType : String {
        
        let gameType = self.rules.trumpSuitePlural
        
        switch gameFlavor
        {
        case .soccer : return "Soccer %@".localizeWith( gameType )
        case .hooligan : return "Hooligan %@".localizeWith( gameType )
        case .bussing : return "Bussing %@".localizeWith( gameType )
        case .straight :
            let no = Game.deck.normalSuitesInDeck.count
            if self.rules.trumpSuite == PlayingCard.Suite.none
            {
                return no.letterDescription + " " + gameType
            }
            return gameType
        }
        
    }

    func random()
    {
        ruleSet = 1 + 3.random
        includeOmnibus = coin
        includeHooligan = coin
        willPassCards = coin
        hasJokers = coin
        hasTrumps = coin
        
        if coin
        {
            noOfCardsInASuite = 14 + 5.random
            noOfSuitesInDeck = 3 + 3.random
            
        } else {
            noOfCardsInASuite = 10 + 5.random
            noOfSuitesInDeck = 5 + 4.random
        }
        
        Game.newDeck()
    }
   
    var rules : IAwarder {
        if data == nil {
            switch ruleSet
            {
            case 2 :
                data = HeartsAwarder(gameSettings: self)
            case 3 :
                data = JacksAwarder(gameSettings: self)
            default :
                data = SpadesAwarder(gameSettings: self)
            }
            specialSuite = (data as! IAwarder).trumpSuite
        }
        return data as! IAwarder
    }
    
    var gameWinningScore : Int { return Game.winningScores[gameWinningScoreIndex] }
    var gameWinningScoreIndex: Int {
        
        get {
            let result = UserDefaults.standard.integer(forKey: MoreProperties.gameWinningScore.rawValue)
            if result == 0
            {
                return 2
            }
            return result
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: MoreProperties.gameWinningScore.rawValue)
            
        }
    }
    func changeSettings(
        _ noOfSuitesInDeck:Int = 4,
        noOfPlayersAtTable:Int  = 4,
        noOfCardsInASuite:Int  = 13,
        hasTrumps:Bool = false,
        hasJokers:Bool = false,
        willPassCards:Bool = true,
        speedOfToss:Int = 3,
        gameWinningScoreIndex:Int = 2,
        ruleSet:Int = 1,
        allowBreakingTrumps:Bool = true,
        includeHooligan:Bool  = false,
        includeOmnibus:Bool  = false,
        useNumbersForCourtCards:Bool  = false,
        noOfHumanPlayers: Int = 1,
        showTips:Bool = true
        ) -> Bool
    {
        if self.noOfSuitesInDeck != noOfSuitesInDeck ||
            self.noOfPlayersAtTable != noOfPlayersAtTable ||
            self.noOfCardsInASuite != noOfCardsInASuite ||
            self.hasTrumps != hasTrumps ||
            self.hasJokers != hasJokers ||
            self.willPassCards != willPassCards ||
            self.gameWinningScoreIndex != gameWinningScoreIndex ||
            self.speedOfToss != speedOfToss ||
            self.ruleSet != ruleSet ||
            self.allowBreakingTrumps != allowBreakingTrumps ||
            self.includeHooligan != includeHooligan ||
            self.includeOmnibus != includeOmnibus ||
            self.useNumbersForCourtCards != useNumbersForCourtCards ||
            self.showTips != showTips
            
        {
            self.noOfSuitesInDeck = noOfSuitesInDeck
            self.noOfPlayersAtTable = noOfPlayersAtTable
            self.noOfCardsInASuite = noOfCardsInASuite
            self.hasTrumps = hasTrumps
            self.hasJokers = hasJokers
            self.willPassCards = willPassCards
            self.speedOfToss = speedOfToss
            self.gameWinningScoreIndex = gameWinningScoreIndex
            self.ruleSet = ruleSet
            self.allowBreakingTrumps = allowBreakingTrumps
            self.includeHooligan = includeHooligan
            self.includeOmnibus = includeOmnibus
            self.useNumbersForCourtCards = useNumbersForCourtCards
            self.noOfHumanPlayers = noOfHumanPlayers
            self.showTips = showTips
            
            
            Game.newDeck(with: self)
            return true
        }
        return false
    }
}

/// For testing
open class FakeGameSettings : IGameSettings
{
    public var noOfSuitesDefault: Int = 5
    public var specialSuite = PlayingCard.Suite.none
    public var isFoolATrump = false
    public var noOfTrumps = 22
    public var noOfStandardTrumps = 21
    public var noOfJokers = 2
    open var hasFool =  true
    open var noOfHumanPlayers : Int  = 1
    open var noOfSuitesInDeck = 6
    open var noOfPlayersAtTable = 5
    open var noOfCardsInASuite = 15
    open var hasTrumps = false
    open var hasJokers = false
    open var showTips = false
    open var allowBreakingTrumps = true
    open var includeHooligan  = false { didSet { update() }}
    open var includeOmnibus  = false { didSet { update() }}
    open var useNumbersForCourtCards  = false
    open var speedOfToss = 3
    open var willPassCards = false
    open var ruleSet = 1
    open var gameWinningScore = 1
    open var isAceHigh  = true
    open var memoryWarning  = true
    open var makeDeckEvenlyDevidable  = true
    open var deck  : PlayingCard.BuiltCardDeck? = nil
    open var gameWinningScoreIndex = 1
    open var gameType = "Spades"
    open var achievementForWin = Achievement.StraightSpades
    
    var awarder : IAwarder? = nil
    open lazy var rules : IAwarder  = SpadesAwarder(gameSettings: self)
    
    open var tossDuration : TimeInterval = 0.4
    public init(noOfSuitesInDeck:Int = 4,noOfPlayersAtTable:Int  = 4,noOfCardsInASuite:Int  = 13,  hasTrumps:Bool = false,  hasJokers:Bool = false)
    {
        self.noOfSuitesInDeck = noOfSuitesInDeck
        self.noOfPlayersAtTable = noOfPlayersAtTable
        self.noOfCardsInASuite = noOfCardsInASuite
        self.hasTrumps = hasTrumps
        self.hasJokers = hasJokers
        deck  = PlayingCard.BuiltCardDeck(gameSettings: self)
    }
    open func update()
    {
        rules  = SpadesAwarder(gameSettings: self)
    }
    open func random() {}
    open func newDeck() {}
    
    open func changeSettings(
        _ noOfSuitesInDeck:Int,
        noOfPlayersAtTable:Int,
        noOfCardsInASuite:Int,
        hasTrumps:Bool,
        hasJokers:Bool,
        willPassCards:Bool,
        speedOfToss:Int,
        gameWinningScoreIndex:Int,
        ruleSet:Int,
        allowBreakingTrumps:Bool,
        includeHooligan:Bool,
        includeOmnibus:Bool,
        useNumbersForCourtCards:Bool,
        noOfHumanPlayers: Int = 1,
        showTips:Bool = true
        ) -> Bool
    {
        return false
    }
}
