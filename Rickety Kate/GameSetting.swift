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
    var speedOfToss  : Int { get }
    var ruleSet  : Int { get }
    
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
    case speedOfToss = "speedOfToss"
    case ruleSet = "ruleSet"
 
}
/// User controlled options for the game
class GameSettings : IGameSettings
{
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
            
        }
    }
    var Rules : IAwarder = StrategicAwarder()
    
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
  
    static let sharedInstance = GameSettings()
    private init() { }
    
    
    static func changeSettings(
        noOfSuitesInDeck:Int = 4,
        noOfPlayersAtTable:Int  = 4,
        noOfCardsInASuite:Int  = 13,
        hasTrumps:Bool = false,
        hasJokers:Bool = false,
        willPassCards:Bool = true,
        speedOfToss:Int = 3,
        ruleSet:Int = 1
        ) -> Bool
    {
        if sharedInstance.noOfSuitesInDeck != noOfSuitesInDeck ||
            sharedInstance.noOfPlayersAtTable != noOfPlayersAtTable ||
            sharedInstance.noOfCardsInASuite != noOfCardsInASuite ||
            sharedInstance.hasTrumps != hasTrumps ||
            sharedInstance.hasJokers != hasJokers ||
            sharedInstance.willPassCards != willPassCards ||
            sharedInstance.speedOfToss != speedOfToss ||
            sharedInstance.ruleSet != ruleSet
        {
        sharedInstance.noOfSuitesInDeck = noOfSuitesInDeck
        sharedInstance.noOfPlayersAtTable = noOfPlayersAtTable
        sharedInstance.noOfCardsInASuite = noOfCardsInASuite
        sharedInstance.hasTrumps = hasTrumps
        sharedInstance.hasJokers = hasJokers
        sharedInstance.willPassCards = willPassCards
        sharedInstance.speedOfToss = speedOfToss
        sharedInstance.ruleSet = ruleSet
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
    public var speedOfToss = 3
    public var willPassCards = false
    public var ruleSet = 1

    public init(noOfSuitesInDeck:Int = 4,noOfPlayersAtTable:Int  = 4,noOfCardsInASuite:Int  = 13,  hasTrumps:Bool = false,  hasJokers:Bool = false)
    {
        
        self.noOfSuitesInDeck = noOfSuitesInDeck
        self.noOfPlayersAtTable = noOfPlayersAtTable
        self.noOfCardsInASuite = noOfCardsInASuite
        self.hasTrumps = hasTrumps
        self.hasJokers = hasJokers
    }
}
