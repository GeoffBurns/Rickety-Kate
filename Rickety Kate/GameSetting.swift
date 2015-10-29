//
//  GameSetting.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 22/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public protocol IGameSettings
{
    var noOfSuitesInDeck : Int { get }
    var noOfPlayersAtTable  : Int { get }
    var noOfCardsInASuite  : Int { get }
    var hasTrumps  : Bool { get }
    var hasJokers : Bool { get }
    var willPassCards  : Bool { get }
    var allowBreakingTrumps  : Bool { get }
    var includeHooligan  : Bool { get }
    var includeOmnibus  : Bool { get }
    var isAceHigh  : Bool { get }
    var makeDeckEvenlyDevidable  : Bool { get }
    var speedOfToss  : Int { get }
    var ruleSet  : Int { get }
    var gameWinningScore  : Int { get  }
    var deck  : PlayingCard.BuiltCardDeck? { get  }
    var rules : IAwarder { get  }
    var tossDuration : NSTimeInterval { get  }
    var gameWinningScoreIndex : Int { get }
    func changeSettings(
        noOfSuitesInDeck:Int,
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
        includeOmnibus:Bool
        ) -> Bool
}
enum GameProperties : String
{
    case NoOfSuitesInDeck = "NoOfSuitesInDeck"
    case NoOfPlayersAtTable = "NoOfPlayersAtTable"
    case NoOfCardsInASuite = "NoOfCardsInASuite"
    case HasTrumps = "HasTrumps"
    case HasJokers = "HasJokers"
    case willPassCards = "willPassCards"
    case ignorePassCards = "ignorePassCards"
    case dontBreakTrumps = "dontBreakTrumps"
    case includeHooligan = "includeHooligan"
    case includeOmnibus = "includeOmnibus"
    case speedOfToss = "speedOfToss"
    case gameWinningScore = "gameWinningScore"
    case ruleSet = "ruleSet"
}
/// User controlled options for the game
public class GameSettings
{
    static var instance : IGameSettings? = nil
    public static var sharedInstance : IGameSettings {
        get{
            if instance == nil
            {
                instance = LiveGameSettings()
            }
            return instance!
        }
        set{
                instance = newValue
        }
    }
    
    static var backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.2, alpha: 1.0)
    
    static var isPad : Bool
    {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
    }
    
    static var isPhone6Plus : Bool
    {
        //  if #available(iOS 8.0, *) {
        return   UIScreen.mainScreen().nativeScale > 2.5
        //    } else {
        //        return UIScreen.mainScreen().bounds.size.height > 735.0
        //    }
    }
    

}
/// User controlled options for the game
class LiveGameSettings : IGameSettings
{
  var deck : PlayingCard.BuiltCardDeck? = nil
  var isAceHigh =  true
  var makeDeckEvenlyDevidable =  true
    
  var noOfSuitesInDeck : Int {
        
    get {
            let result = NSUserDefaults.standardUserDefaults().integerForKey(GameProperties.NoOfSuitesInDeck.rawValue)
            if result == 0
            {
                return 6
            }
            return result
    }
    set (newValue) {
    NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: GameProperties.NoOfSuitesInDeck.rawValue)

    ////  NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
    
    var noOfPlayersAtTable : Int {
        
        get {
            let result = NSUserDefaults.standardUserDefaults().integerForKey(GameProperties.NoOfPlayersAtTable.rawValue)
            if result == 0
            {
                return 5
            }
            return result
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: GameProperties.NoOfPlayersAtTable.rawValue)
            
        }
    }
    var noOfCardsInASuite : Int {
        
        get {
            let result = NSUserDefaults.standardUserDefaults().integerForKey(GameProperties.NoOfCardsInASuite.rawValue)
            if result == 0
            {
                return 16
            }
            return result
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: GameProperties.NoOfCardsInASuite.rawValue)
            
        }
    }
    
    var willPassCards : Bool {
        
        get {
            return !NSUserDefaults.standardUserDefaults().boolForKey(GameProperties.ignorePassCards.rawValue)
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setBool(!newValue, forKey: GameProperties.ignorePassCards.rawValue)
        }
    }
    var allowBreakingTrumps : Bool {
        
        get {
            return !NSUserDefaults.standardUserDefaults().boolForKey(GameProperties.dontBreakTrumps.rawValue)
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setBool(!newValue, forKey: GameProperties.dontBreakTrumps.rawValue)
        }
    }
    var includeHooligan : Bool {
        
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(GameProperties.includeHooligan.rawValue)
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: GameProperties.includeHooligan.rawValue)
        }
    }
    var includeOmnibus : Bool {
        
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(GameProperties.includeOmnibus.rawValue)
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: GameProperties.includeOmnibus.rawValue)
        }
    }

    var speedOfToss : Int {
        
        get {
            let result = NSUserDefaults.standardUserDefaults().integerForKey(GameProperties.speedOfToss.rawValue)
            if result == 0
            {
                return 3
            }
            return result
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: GameProperties.speedOfToss.rawValue)
        }
    }
    
    var tossDurations : [NSTimeInterval] = [ 1.0, 0.85, 0.7, 0.5, 0.4, 0.25, 0.18, 0.15, 0.1, 0.05]
    var tossDuration : NSTimeInterval { return tossDurations[speedOfToss] }
    
    var ruleSet : Int {
        
        get {
            let result = NSUserDefaults.standardUserDefaults().integerForKey(GameProperties.ruleSet.rawValue)
            if result == 0
            {
                return 1
            }
            return result
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: GameProperties.ruleSet.rawValue)
            awarder = nil
        }
    
    }

    
    var awarder : IAwarder? = nil
    var rules : IAwarder {
        if awarder == nil {
            switch ruleSet
            {
            case 2 :
                awarder = HeartsAwarder(gameSettings: self)
            case 3 :
                awarder = JacksAwarder(gameSettings: self)
            default :
                awarder = SpadesAwarder(gameSettings: self)
    
            }
            
        }
        return awarder!
    }
    var gameWinningScores : [Int] = [ 20 , 50, 100, 150, 200, 250, 300, 500, 600]
    var gameWinningScore : Int { return gameWinningScores[gameWinningScoreIndex] }
    var gameWinningScoreIndex: Int {
        
        get {
            let result = NSUserDefaults.standardUserDefaults().integerForKey(GameProperties.gameWinningScore.rawValue)
            if result == 0
            {
                return 2
            }
            return result
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: GameProperties.gameWinningScore.rawValue)
            
        }
    }
    
    var hasTrumps : Bool {
        
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(GameProperties.HasTrumps.rawValue)
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: GameProperties.HasTrumps.rawValue)
        }
    }
    
    var hasJokers : Bool {
        
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(GameProperties.HasJokers.rawValue)
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: GameProperties.HasJokers.rawValue)
        }
    }
 
    init() {
   
 
    deck = PlayingCard.BuiltCardDeck(gameSettings: self)
    
    }
    
    func changeSettings(
        noOfSuitesInDeck:Int = 4,
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
        includeOmnibus:Bool  = false
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
            self.includeOmnibus != includeOmnibus
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
            self.deck = PlayingCard.BuiltCardDeck(gameSettings: self)
            self.allowBreakingTrumps = allowBreakingTrumps
            self.includeHooligan = includeHooligan
            self.includeOmnibus = includeOmnibus
            
            return true
        }
        return false
    }

 }

/// For testing
public class FakeGameSettings : IGameSettings
{
    public var noOfSuitesInDeck = 6
    public var noOfPlayersAtTable = 5
    public var noOfCardsInASuite = 15
    public var hasTrumps = false
    public var hasJokers = false
    public var allowBreakingTrumps = true
    public var includeHooligan  = false
    public var includeOmnibus  = false
    public var speedOfToss = 3
    public var willPassCards = false
    public var ruleSet = 1
    public var gameWinningScore = 1
    public var isAceHigh  = true
    public var makeDeckEvenlyDevidable  = true
    public var deck  : PlayingCard.BuiltCardDeck? = nil
    public var gameWinningScoreIndex = 1
    var awarder : IAwarder? = nil
    public var rules : IAwarder {
        if awarder == nil{
           awarder = SpadesAwarder(gameSettings: self)
        }
        return awarder!
    }
    public var tossDuration : NSTimeInterval = 0.4
    public init(noOfSuitesInDeck:Int = 4,noOfPlayersAtTable:Int  = 4,noOfCardsInASuite:Int  = 13,  hasTrumps:Bool = false,  hasJokers:Bool = false)
    {
        self.noOfSuitesInDeck = noOfSuitesInDeck
        self.noOfPlayersAtTable = noOfPlayersAtTable
        self.noOfCardsInASuite = noOfCardsInASuite
        self.hasTrumps = hasTrumps
        self.hasJokers = hasJokers
        deck  = PlayingCard.BuiltCardDeck(gameSettings: self)
    }
    
    public func changeSettings(
        noOfSuitesInDeck:Int,
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
        includeOmnibus:Bool
        ) -> Bool
    {
        return false
    }
}
