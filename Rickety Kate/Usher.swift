//
//  Usher.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 31/12/2015.
//  Copyright © 2015 Geoff Burns All rights reserved.
//

import Foundation
import Cards

/// organize list of players for game
class Usher {
    
    static let computerPlayers = [ComputerPlayer(name:"Fred",margin: 2),ComputerPlayer(name:"Molly",margin: 3),ComputerPlayer(name:"Greg",margin: 1),ComputerPlayer(name:"Sarah",margin: 4),ComputerPlayer(name:"Warren",margin: 5),ComputerPlayer(name:"Linda",margin: 3),ComputerPlayer(name:"Rita",margin: 4)]
    
    
    /// create list of game players
    static func players(_ noOfPlayers:Int,noOfHumans:Int) -> [CardPlayer]
    {
        if noOfHumans == 0 {
            return Array(computerPlayers[0..<noOfPlayers])
        }
        
        let noOfComputerPlayers = noOfPlayers - noOfHumans
        
        
        
        let humans = (1...noOfHumans).map { HumanPlayer(name: "player".localize + $0.description,
                                                        sound: "player"+String($0)) as CardPlayer }
        
        if let gameCenterName = GameKitHelper.sharedInstance.gameCenterName {
            humans[0].name = gameCenterName
        } else if noOfHumans == 1 {
            humans[0].name = GameKitHelper.sharedInstance.displayName
        }
        if noOfComputerPlayers <= 0 { return humans }
        return humans + Array(computerPlayers[0..<noOfComputerPlayers])
    }
}

extension CardPlayer
{

    ///////////////////////////////////////////
    /// Static Functions
    ///////////////////////////////////////////
    static func demoPlayers(_ noOfPlayers:Int) -> [CardPlayer]
    {
        return Usher.players(noOfPlayers,noOfHumans: 0)
    }
    
    static func gamePlayers(_ noOfPlayers:Int) -> [CardPlayer]
    {
        var noOfHumanPlayers = Game.settings.noOfHumanPlayers
        noOfHumanPlayers = noOfHumanPlayers < 1 ? 1 : noOfHumanPlayers
        noOfHumanPlayers = noOfHumanPlayers > noOfPlayers ? noOfPlayers : noOfHumanPlayers
        
        return Usher.players(noOfPlayers,noOfHumans: noOfHumanPlayers)
}
}
