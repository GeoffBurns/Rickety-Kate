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

public protocol ICardGameSettings
{
    var noOfSuitesInDeck : Int { get }
    var noOfSuitesDefault : Int { get set }
    var noOfPlayersAtTable  : Int { get }
    var noOfHumanPlayers : Int { get }
    var noOfCardsInASuite  : Int { get }
    var hasTrumps  : Bool { get }
    var hasJokers : Bool { get set}
    var hasFool : Bool { get }
    var isFoolATrump : Bool { get set}
    var showTips : Bool { get }
    var willPassCards  : Bool { get }
    var useNumbersForCourtCards : Bool { get }
    var isAceHigh  : Bool { get set}
    var makeDeckEvenlyDevidable  : Bool { get }
    var speedOfToss  : Int { get }
    var tossDuration : TimeInterval { get  }
    var memoryWarning : Bool { get set }
    var noOfTrumps : Int { get }
    var noOfStandardTrumps : Int { get }
    var noOfJokers : Int { get }
    var specialSuite : PlayingCard.Suite { get }
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
    case speedOfToss = "speedOfToss"
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
    static var isPhoneX : Bool
    {
        return UIScreen.main.nativeBounds.height == 2436
    }
    static var isPhone55inch : Bool
    {
        return UIScreen.main.nativeBounds.height == 2208
    }
    
    static var isPadPro : Bool
    {
        let size = UIScreen.main.applicationFrame
        return size.width > 1250 || size.height > 1250
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
public class Game
{
    public static var settings : ICardGameSettings = LiveGameSettings()
    static var _deck  : PlayingCard.BuiltCardDeck? = nil

    static var deck  : PlayingCard.BuiltCardDeck {
     
        if _deck == nil { newDeck() }
        return _deck!
      
    }
    
    static func newDeck() {
        _deck = PlayingCard.BuiltCardDeck(gameSettings: settings)
    }
    public static func newDeck(with: ICardGameSettings) {
        _deck = PlayingCard.BuiltCardDeck(gameSettings: with)
    }
    static var backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.2, alpha: 1.0)
}

/// User controlled options for the game
class LiveGameSettings : ICardGameSettings
{
    var specialSuite: PlayingCard.Suite  = PlayingCard.Suite.none
    var isFoolATrump = false
    var noOfJokers = 2
    var noOfStandardTrumps = 21
    var noOfTrumps: Int { return hasFool ? noOfStandardTrumps + 1 : noOfStandardTrumps }
    var isAceHigh =  true
    internal var hasFool =  true
    internal var noOfHumanPlayers : Int  = 1
    internal var makeDeckEvenlyDevidable  =  true
    internal var noOfSuitesDefault : Int  = 5
    
    var memoryWarning : Bool {
        get {
            return UserDefaults.standard.bool(forKey: GameProperties.memoryWarning.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: GameProperties.memoryWarning.rawValue)
        }
    }
    
  var noOfSuitesInDeck : Int {
        
    get {
            let result = UserDefaults.standard.integer(forKey: GameProperties.NoOfSuitesInDeck.rawValue)
            if result == 0
            {
                return noOfSuitesDefault
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
    
 
    var coin : Bool
    {
        return 0 == 2.random
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
 
    var data : AnyObject? = nil
    


 }


