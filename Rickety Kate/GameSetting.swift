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
    case phone
    case pad
    case bigPhone
    case bigPad
}
public enum LayoutType
{
    case phone
    case pad
    case portrait
}

public enum GameFlavor
{
    
    case hooligan
    case soccer
    case bussing
    case straight
    
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
    var showTips : Bool { get }
    var willPassCards  : Bool { get }
    var useNumbersForCourtCards : Bool { get }
    var isAceHigh  : Bool { get }
    var makeDeckEvenlyDevidable  : Bool { get }
    var deck  : PlayingCard.BuiltCardDeck? { get  }
    var speedOfToss  : Int { get }
    var tossDuration : TimeInterval { get  }
    var memoryWarning : Bool { get set }
    
    func newDeck()
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
    case hideTips = "hideTips"
}

/// User controlled options for the game
open class DeviceSettings
{
    static var isPad : Bool
    {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    static var isPhone : Bool
    {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    static var isPortrait : Bool
    {
        let size = UIScreen.main.applicationFrame
        return size.width < size.height
    }
    static var isBigPhone : Bool
    {
        return   UIScreen.main.nativeScale > 2.5
    }
    static var isBigPad : Bool
    {
        return   isPad && UIScreen.main.nativeScale > 1.9
        
    }
    static var isBiggerDevice: Bool
    {
        return isBigPhone || isBigPad
    }
    static var isBigDevice: Bool
    {
        return isBigPhone || isPad
    }
    static var isSmallDevice: Bool
    {
        return !isBigPhone && !isPad
    }
    static  var device : DeviceType {
        
        if isPad
        {
            if isBigPad
            {
                return .bigPad
            }
            return .pad
        }
        if isBigPhone
        {
            return .bigPhone
        }
        return .phone
    }
    static  var layout : LayoutType {
        
        if isPad
        {
            if isPortrait
            {
                return .portrait
            }
            return .pad
        }
        return .phone
    }
}

/// User controlled options for the game
open class GameSettings
{
    static var instance : IGameSettings? = nil
    open static var sharedInstance : IGameSettings {
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
            let result = UserDefaults.standard.integer(forKey: GameProperties.NoOfSuitesInDeck.rawValue)
            if result == 0
            {
                return 5
            }
            return result
    }
    set (newValue) {
    UserDefaults.standard.set(newValue, forKey: GameProperties.NoOfSuitesInDeck.rawValue)

   
    }
  }
    
    var noOfPlayersAtTable : Int {
        
        get {
            let result = UserDefaults.standard.integer(forKey: GameProperties.NoOfPlayersAtTable.rawValue)
            if result == 0
            {
                return 5
            }
            return result
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.NoOfPlayersAtTable.rawValue)
            
        }
    }
    var noOfCardsInASuite : Int {
        
        get {
            let result = UserDefaults.standard.integer(forKey: GameProperties.NoOfCardsInASuite.rawValue)
            if result == 0
            {
                return 14
            }
            return result
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.NoOfCardsInASuite.rawValue)
        }
    }
    
    var memoryWarning : Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: GameProperties.memoryWarning.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.memoryWarning.rawValue)
        }
    }
    
    var showTips : Bool {
        
        get {
            return !UserDefaults.standard.bool(forKey: GameProperties.hideTips.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(!newValue, forKey: GameProperties.hideTips.rawValue)
        }
    }
    
    var willPassCards : Bool {
        
        get {
            return !UserDefaults.standard.bool(forKey: GameProperties.ignorePassCards.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(!newValue, forKey: GameProperties.ignorePassCards.rawValue)
        }
    }
    
    var useNumbersForCourtCards : Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: GameProperties.useNumbersForCourtCards.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.useNumbersForCourtCards.rawValue)
        }
    }
    var allowBreakingTrumps : Bool {
        
        get {
            return !UserDefaults.standard.bool(forKey: GameProperties.dontBreakTrumps.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(!newValue, forKey: GameProperties.dontBreakTrumps.rawValue)
        }
    }
    var includeHooligan : Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: GameProperties.includeHooligan.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.includeHooligan.rawValue)
        }
    }
    var includeOmnibus : Bool {
        
        get {
            let result = UserDefaults.standard.bool(forKey: GameProperties.includeOmnibus.rawValue)
            if let deck1 = self.deck {  return result && deck1.setOfSuitesInDeck.contains(PlayingCard.Suite.diamonds) }
            
            return result
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.includeOmnibus.rawValue)
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
            let defaults = UserDefaults.standard
            let key = GameProperties.speedOfToss.rawValue
            let result = defaults.integer(forKey: key)
            if result > 0 && result < 8
            {
                return result
            }
             return 3
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.speedOfToss.rawValue)
        }
    }
    
    var tossDurations : [TimeInterval] = [ 1.0, 0.85, 0.7, 0.5, 0.4, 0.25, 0.18, 0.15, 0.1, 0.05]
    var tossDuration : TimeInterval { return tossDurations[speedOfToss] }
    
    var ruleSet : Int {
        get {
            let result = UserDefaults.standard.integer(forKey: GameProperties.ruleSet.rawValue)
            if result == 0
            {
                return 1
            }
            return result
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.ruleSet.rawValue)
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
               if let no = self.deck?.normalSuitesInDeck.count, self.rules.trumpSuite == PlayingCard.Suite.none
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
        
        newDeck()
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
            let result = UserDefaults.standard.integer(forKey: GameProperties.gameWinningScore.rawValue)
            if result == 0
            {
                return 2
            }
            return result
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.gameWinningScore.rawValue)
            
        }
    }
    
    var hasTrumps : Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: GameProperties.HasTrumps.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.HasTrumps.rawValue)
        }
    }
    
    var hasJokers : Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: GameProperties.HasJokers.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.HasJokers.rawValue)
        }
    }
 
    
    func newDeck() {
         deck = PlayingCard.BuiltCardDeck(gameSettings: self)
    }
    
    init() {  newDeck() }
    
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
            
            
            self.deck = PlayingCard.BuiltCardDeck(gameSettings: self)
            return true
        }
        return false
    }

 }

/// For testing
open class FakeGameSettings : IGameSettings
{
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
