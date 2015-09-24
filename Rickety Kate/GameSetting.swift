//
//  GameSetting.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 22/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation

/// User controlled options for the game
class GameSettings
{
    var noOfSuitesInDeck = 6
    var noOfPlayersAtTable = 5
    var noOfCardsInASuite = 15
    
    static let sharedInstance = GameSettings()
    private init() { }
    
    static func changeSettings(noOfSuitesInDeck:Int = 4,noOfPlayersAtTable:Int  = 4,noOfCardsInASuite:Int  = 13) -> Bool
    {
        if sharedInstance.noOfSuitesInDeck != noOfSuitesInDeck ||
        sharedInstance.noOfPlayersAtTable != noOfPlayersAtTable ||
        sharedInstance.noOfCardsInASuite != noOfCardsInASuite
        
        {
        sharedInstance.noOfSuitesInDeck = noOfSuitesInDeck
        sharedInstance.noOfPlayersAtTable = noOfPlayersAtTable
        sharedInstance.noOfCardsInASuite = noOfCardsInASuite
            return true
        }
        return false
    }
    
    
}
