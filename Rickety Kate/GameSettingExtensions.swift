//
//  GameSettingExtensions.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//

import Foundation
import Cards

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

}
enum MoreProperties : String
{
    case dontBreakTrumps = "dontBreakTrumps"
    case includeHooligan = "includeHooligan"
    case includeOmnibus = "includeOmnibus"
    case ruleSet = "ruleSet"
    case gameWinningScore = "gameWinningScore"

}

extension  YesNoOption
{
    convenience init(inverted:Bool, prompt: String, key: MoreProperties)
    {
        self.init(inverted:inverted, prompt: prompt, key: key.rawValue)
    }
}

extension  RangeOption
{
    convenience init(min:Int, max:Int, defaultValue:Int, prompt: String, key: MoreProperties)
    {
        self.init(min:min, max:max, defaultValue:defaultValue, prompt: prompt, key: key.rawValue)
    }
}

extension  SelectOption
{
    convenience init(selections:[String], defaultValue:Int,  prompt: String, key: MoreProperties)
    {
        self.init(selections:selections, defaultValue:defaultValue,  prompt: prompt, key: key.rawValue)
    }
}

extension Game
{
    public static var moreSettings : IGameSettings { return settings as! IGameSettings}
    public static var rules : IAwarder { return moreSettings.rules }
    public static let winningScores : [Int] = [ 20 , 50, 100, 150, 200, 250, 300, 500, 600]
}

public class MoreOptions
{
    
    static var allowBreaking = YesNoOption(inverted: true, prompt: "Allow Breaking Trumps", key: MoreProperties.dontBreakTrumps)

    
    static var hooligan = YesNoOption(inverted: false, prompt: "Include Hooligan", key: MoreProperties.includeHooligan)

    
    static var omnibus = YesNoOption(inverted: false, prompt: "Include Omnibus", key: MoreProperties.includeOmnibus)

    
    static var winningScore = SelectOption( selections: ["50", "100", "150", "200", "250", "300", "500"], defaultValue: 2, prompt: "Game Finishing Score", key: MoreProperties.gameWinningScore)
    
    static var ruleSet = SelectOption( selections: ["Spades","Hearts","Jacks"], defaultValue: 1, prompt: "Rule Set", key: MoreProperties.ruleSet)
 

    
}

extension LiveGameSettings : IGameSettings
{

    public var allowBreakingTrumps : Bool {
        
        get { return MoreOptions.allowBreaking.value }
        set (newValue) { MoreOptions.allowBreaking.value = newValue }
    }
    
    public var includeHooligan : Bool {
        
        get { return MoreOptions.hooligan.value && Game.deck.setOfSuitesInDeck.contains(PlayingCard.Suite.clubs) }
        set (newValue) { MoreOptions.hooligan.value = newValue }
    }
    
  
    public var includeOmnibus : Bool {
        
        get { return MoreOptions.omnibus.value  && Game.deck.setOfSuitesInDeck.contains(PlayingCard.Suite.diamonds) }
        set (newValue) { MoreOptions.omnibus.value = newValue }
    }
    
    public var gameWinningScoreIndex:  Int {
        get { return MoreOptions.winningScore.value }
        set (newValue) { MoreOptions.winningScore.value = newValue }
    }
    public var gameWinningScore : Int { return Game.winningScores[gameWinningScoreIndex] }
    
    public var ruleSet : Int {
        get { return MoreOptions.ruleSet.value }
        set (newValue) { MoreOptions.ruleSet.value = newValue ; data = nil }
    
    }
    
    public var rules : IAwarder {
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
    public var achievementForWin : Achievement
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
    
    public var gameType : String {
        
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

    public func random()
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

  


}

/// For testing
open class FakeGameSettings : IGameSettings
{
    public func clearData(_: Int) { }
    public func cacheSpeed(_: Int) { }
    public var options: [SaveableOption] = []
    public var noOfSuitesDefault: Int = 5
    public var specialSuite = PlayingCard.Suite.none
    public var isFoolATrump = false
    public var noOfTrumps = 22
    public var noOfStandardTrumps = 21
    public var noOfJokers = 2
    public var willPassThePhone = false
    public var isServer = false
    public var isClient = false
    public var willRemoveLow = true
    open var hasFool =  true
    open var noOfHumanPlayers : Int  = 1
    open var noOfSuitesInDeck = 6
    open var noOfPlayersAtTable = 5
    open var noOfCardsInASuite = 15
    open var hasTrumps = false
    open var hasJokers = false
    open var showTips = false
    open var isPlayingMusic = false
    open var isPlayingSound = false
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
    
    open func changed() -> Bool
    {
        return false
    }
}
