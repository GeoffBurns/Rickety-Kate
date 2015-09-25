//
//  Scorer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 18/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

/// Calculate the Result of the trick
class Scorer
{
    var scores = [Int]()
    var wins = [Int]()
    var scoresForHand = [Int]()
    
    var players = [CardPlayer]()
    var lookup = Dictionary<String,Int>()
    
    static let sharedInstance = Scorer()
    private init() { }
    
    static func winnerIs(gameState:GameStateBase) -> CardPlayer?
    {
        return sharedInstance.trickWon(gameState)
    }
    func setupScorer( players: [CardPlayer])
    {
        scores = []
        scoresForHand  = []
        wins  = []
        var i = 0
        self.players=players
        for player in players
        {
            scores.append(0)
            
            scoresForHand.append(0)
            wins.append(0)
            lookup.updateValue(i, forKey: player.name)

            i++
        }
    }

    static func playerThatWon(gameState:GameStateBase) -> CardPlayer?
    {
        if let trick = gameState.tricksPile.first
        {
            let leadingSuite = trick.playedCard.suite
            let followingTricks = gameState.tricksPile.filter { $0.playedCard.suite == leadingSuite }
            
            let orderedTricks = followingTricks.sort({ $0.playedCard.value > $1.playedCard.value })
            if let highest = orderedTricks.first
            {
                return highest.player
            }
        }
        return nil
}
    /// Did player get all the points avalilable in his hand
    func hasShotTheMoon() -> Bool
    {
    var hasShotMoon = false
    for (i,player) in self.players.enumerate()
     {
     /// Did player get all the points avalilable in his hand
     let allPoints = 9 + GameSettings.sharedInstance.noOfCardsInASuite
     if self.scoresForHand[i] >= allPoints
      {
      self.scores[i] = 0
      ScoreDisplay.publish(player,score: self.scores[i], wins: self.wins[i])
      hasShotMoon = true
      if player.name == "You"
          {
          StatusDisplay.publish("Congratulatons!!!",message2: "You just shot the Moon")
          
          }
       else
          {
         StatusDisplay.publish("Wow!!!",message2: "\(player.name) just shot the Moon")
          }
    
      }
     self.scoresForHand[i] = 0

     }
        
        var lowestScore = 1000
        var winner = -10
        var hasWonGame = false
        var isDraw = false
   
        for i in 0..<self.players.count
        {
            if self.scores[i] < lowestScore
            {
                lowestScore = self.scores[i]
                winner = i
                isDraw = false
            } else  if self.scores[i] == lowestScore
            {
               isDraw = true
            }
                
            if self.scores[i] >= 100
            {
                hasWonGame = true
            }
         
        }
        
        let isGameWon = hasWonGame && !isDraw
        if isGameWon
        {
            self.wins[winner] = self.wins[winner] + 1
          
            for (i,player) in players.enumerate()
            {
                scores[i] = 0
                scoresForHand[i] = 0
                ScoreDisplay.publish(player,score: self.scores[i], wins: self.wins[i])
          
            }
            if winner == 0
            {
                StatusDisplay.publish("Congratulatons!!!",message2: "You just won the game")
                
            }
            else
            {
                StatusDisplay.publish("Wow!!!",message2: "\(players[winner].name) just won the game")
            }
            return hasShotMoon
        }
        if(hasShotMoon)
        {
        //    self.runAction(SKAction.sequence([SKAction.waitForDuration(self.cardTossDuration), SKAction.runBlock({
                
        //        StatusDisplay.publish("New Hand" )
        //    })]))
        } else {
            
            StatusDisplay.publish("New Hand" )
        }
        
        return hasShotMoon
    }

    func trickWon(gameState:GameStateBase) -> CardPlayer?
    {
        if let winner = Scorer.playerThatWon(gameState)
        {
            
            if let winnerIndex = players.indexOf(winner)
            {
                let score = Awarder.sharedInstance.scoreFor(gameState.tricksPile.map { return $0.playedCard} , winnersName: winner.name)
                if(score>0)
                {
                    self.scores[winnerIndex] += score
                    self.scoresForHand[winnerIndex] += score
                    ScoreDisplay.publish(winner,score: self.scores[winnerIndex], wins:self.wins[winnerIndex])
                }
            }
            
            return winner
            
        }
        return nil
    }
}
    