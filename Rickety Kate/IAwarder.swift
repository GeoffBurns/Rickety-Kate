//
//  IAwarder.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 14/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//

import Foundation
import Cards


public protocol IAwarder
{
    var allPoints : Int { get }
    var ricketyKatePoints : Int { get }
    var trumpSuite : PlayingCard.Suite { get }
    var trumpSuiteSingular : String { get }
    var trumpSuitePlural : String  { get }
    var description : String { get }
    var shortDescription : String { get }
    var cardScores : Dictionary<PlayingCard,Int> { get }
    var bonusCards : Set<PlayingCard> { get }
    var penaltyCards : Set<PlayingCard> { get }
    var omnibus : PlayingCard? { get }
    var hooligan : PlayingCard? { get }
    var backgroundCards : [PlayingCard] { get }
    var leaderboard : LeaderBoard { get }
    func scoreFor(_ cards: [PlayingCard], winner: CardPlayer) ->Int
    func AchievementForWin(_ gameFlavor:GameFlavor) ->  Achievement
    
}
