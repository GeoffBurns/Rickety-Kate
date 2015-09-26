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
}

/// User controlled options for the game
class GameSettings : IGameSettings
{
    var noOfSuitesInDeck = 6
    var noOfPlayersAtTable = 5
    var noOfCardsInASuite = 15
    var hasTrumps = false
    var hasJokers = false
    
    static var isPad : Bool
        {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        }
    
    static let sharedInstance = GameSettings()
    private init() { }
    
    static func changeSettings(noOfSuitesInDeck:Int = 4,noOfPlayersAtTable:Int  = 4,noOfCardsInASuite:Int  = 13,  hasTrumps:Bool = false,  hasJokers:Bool = false) -> Bool
    {
        if sharedInstance.noOfSuitesInDeck != noOfSuitesInDeck ||
            sharedInstance.noOfPlayersAtTable != noOfPlayersAtTable ||
            sharedInstance.noOfCardsInASuite != noOfCardsInASuite ||
            sharedInstance.hasTrumps != hasTrumps ||
            sharedInstance.hasJokers != hasJokers
        
        {
        sharedInstance.noOfSuitesInDeck = noOfSuitesInDeck
        sharedInstance.noOfPlayersAtTable = noOfPlayersAtTable
        sharedInstance.noOfCardsInASuite = noOfCardsInASuite
        sharedInstance.hasTrumps = hasTrumps
        sharedInstance.hasJokers = hasJokers
            
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

    public init(noOfSuitesInDeck:Int = 4,noOfPlayersAtTable:Int  = 4,noOfCardsInASuite:Int  = 13,  hasTrumps:Bool = false,  hasJokers:Bool = false)
    {
        
        self.noOfSuitesInDeck = noOfSuitesInDeck
        self.noOfPlayersAtTable = noOfPlayersAtTable
        self.noOfCardsInASuite = noOfCardsInASuite
        self.hasTrumps = hasTrumps
        self.hasJokers = hasJokers
    }
}
