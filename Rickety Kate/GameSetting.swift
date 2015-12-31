//
//  GameSetting.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 22/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

public enum DeviceType
{
    case Phone
    case Pad
    case BigPhone
    case BigPad
}
public enum LayoutType
{
    case Phone
    case Pad
    case Portrait
}

public enum GameFlavor
{
    
    case Hooligan
    case Soccer
    case Bussing
    case Straight
    
}

public protocol ICardGameSettings
{
    var noOfSuitesInDeck : Int { get }
    var noOfPlayersAtTable  : Int { get }
    var noOfHumanPlayers : Int { get }
    var noOfCardsInASuite  : Int { get }
    var hasTrumps  : Bool { get }
    var hasJokers : Bool { get }
    var hasFool : Bool { get }
    var willPassCards  : Bool { get }
    var useNumbersForCourtCards : Bool { get }
    var isAceHigh  : Bool { get }
    var makeDeckEvenlyDevidable  : Bool { get }
    var deck  : PlayingCard.BuiltCardDeck? { get  }
    var speedOfToss  : Int { get }
    var tossDuration : NSTimeInterval { get  }
    var memoryWarning : Bool { get set }
    
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
        includeOmnibus:Bool,
        useNumbersForCourtCards:Bool,
        noOfHumanPlayers: Int
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
    case useNumbersForCourtCards = "useNumbersForCourtCards"
    case dontBreakTrumps = "dontBreakTrumps"
    case includeHooligan = "includeHooligan"
    case includeOmnibus = "includeOmnibus"
    case speedOfToss = "speedOfToss"
    case gameWinningScore = "gameWinningScore"
    case ruleSet = "ruleSet"
    case memoryWarning = "memoryWarning"
}

/// User controlled options for the game
public class DeviceSettings
{
    static var isPad : Bool
    {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
    }
    static var isPhone : Bool
    {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
    }
    static var isPortrait : Bool
    {
        let size = UIScreen.mainScreen().applicationFrame
        return size.width < size.height
    }
    static var isBigPhone : Bool
    {
        return   UIScreen.mainScreen().nativeScale > 2.5
    }
    static var isBigPad : Bool
    {
        return   isPad && UIScreen.mainScreen().nativeScale > 1.9
        
    }
    static var isBiggerDevice: Bool
    {
        return isBigPhone || isBigPad
    }
    static var isBigDevice: Bool
    {
        return isBigPhone || isPad
    }
    
    static  var device : DeviceType {
        
        if isPad
        {
            if isBigPad
            {
                return .BigPad
            }
            return .Pad
        }
        if isBigPhone
        {
            return .BigPhone
        }
        return .Phone
    }
    static  var layout : LayoutType {
        
        if isPad
        {
            if isPortrait
            {
                return .Portrait
            }
            return .Pad
        }
        return .Phone
    }
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
        set {
                instance = newValue
        }
    }
    static var backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.2, alpha: 1.0)
}

/// User controlled options for the game
class LiveGameSettings : IGameSettings
{
    var deck : PlayingCard.BuiltCardDeck? = nil
    var isAceHigh =  true
    internal var hasFool =  true
    internal var noOfHumanPlayers : Int  = 1
    internal var makeDeckEvenlyDevidable  =  true
    
  var noOfSuitesInDeck : Int {
        
    get {
            let result = NSUserDefaults.standardUserDefaults().integerForKey(GameProperties.NoOfSuitesInDeck.rawValue)
            if result == 0
            {
                return 5
            }
            return result
    }
    set (newValue) {
    NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: GameProperties.NoOfSuitesInDeck.rawValue)

   
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
                return 14
            }
            return result
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: GameProperties.NoOfCardsInASuite.rawValue)
        }
    }
    
    var memoryWarning : Bool {
        
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(GameProperties.memoryWarning.rawValue)
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: GameProperties.memoryWarning.rawValue)
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
    
    var useNumbersForCourtCards : Bool {
        
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(GameProperties.useNumbersForCourtCards.rawValue)
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: GameProperties.useNumbersForCourtCards.rawValue)
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
            if __speedOfToss == nil
            {
                __speedOfToss = _speedOfToss
            }
            return __speedOfToss!
        }
        set (newValue) {
            __speedOfToss = newValue
            _speedOfToss = newValue
        }
    }
    
    var __speedOfToss : Int? = nil
    var _speedOfToss : Int {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            let key = GameProperties.speedOfToss.rawValue
            let result = defaults.integerForKey(key)
            if result > 0 && result < 8
            {
                return result
            }
             return 3
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
    
    var achievementForWin : Achievement
    {
            return self.rules.AchievementForWin(gameFlavor)
    }
    
    var gameFlavor : GameFlavor
        {
            if includeHooligan  {
                if includeOmnibus { return .Soccer }
                return .Hooligan
            }
            
            if includeOmnibus { return .Bussing }
            return .Straight
    }

    

    var gameType : String {
        
        let gameType = self.rules.trumpSuitePlural
        
        switch gameFlavor
        {
        case .Soccer : return "Soccer _".localizeWith( gameType )
        case .Hooligan : return "Hooligan _".localizeWith( gameType )
        case .Bussing : return "Bussing _".localizeWith( gameType )
        case .Straight :
               if let no = self.deck?.normalSuitesInDeck.count
                  where self.rules.trumpSuite == PlayingCard.Suite.None
                            {
                                return no.letterDescription + " " + gameType
                            }
               return gameType
        }

    }
    var coin : Bool
    {
        return 0 == 2.random
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
        includeOmnibus:Bool  = false,
        useNumbersForCourtCards:Bool  = false,
        noOfHumanPlayers: Int = 1
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
            self.useNumbersForCourtCards != useNumbersForCourtCards
            
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
            self.useNumbersForCourtCards = useNumbersForCourtCards
            self.noOfHumanPlayers = noOfHumanPlayers
            return true
        }
        return false
    }

 }

/// For testing
public class FakeGameSettings : IGameSettings
{
    public var hasFool =  true
    public var noOfHumanPlayers : Int  = 1
    public var noOfSuitesInDeck = 6
    public var noOfPlayersAtTable = 5
    public var noOfCardsInASuite = 15
    public var hasTrumps = false
    public var hasJokers = false
    public var allowBreakingTrumps = true
    public var includeHooligan  = false { didSet { update() }}
    public var includeOmnibus  = false { didSet { update() }}
    public var useNumbersForCourtCards  = false
    public var speedOfToss = 3
    public var willPassCards = false
    public var ruleSet = 1
    public var gameWinningScore = 1
    public var isAceHigh  = true
    public var memoryWarning  = true
    public var makeDeckEvenlyDevidable  = true
    public var deck  : PlayingCard.BuiltCardDeck? = nil
    public var gameWinningScoreIndex = 1
    public var gameType = "Spades"
    public var achievementForWin = Achievement.StraightSpades

    var awarder : IAwarder? = nil
    public lazy var rules : IAwarder  = SpadesAwarder(gameSettings: self)
    
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
    public func update()
    {
        rules  = SpadesAwarder(gameSettings: self)
    }
    public func random() {}
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
        includeOmnibus:Bool,
        useNumbersForCourtCards:Bool,
        noOfHumanPlayers: Int = 1
        ) -> Bool
    {
        return false
    }
}
