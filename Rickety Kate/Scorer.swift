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
    var scores = [Score]()
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
        scoresForHand = []
        self.players=players
        
        for (i, player) in players.enumerate()
        {
            scores.append(Score(playerName: player.name,currentScore: 0,totalWins: 0))
            scoresForHand.append(0)

            lookup.updateValue(i, forKey: player.name)
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
    
    func recordTheScoresForAGameWin(winnerIndex:Int)
    {
    self.scores[winnerIndex].totalWins = self.scores[winnerIndex].totalWins + 1
    
    for (i,score) in scores.enumerate()
      {
      scores[i].currentScore = 0
      ScoreDisplay.publish(score)
      }
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
         self.scores[i].currentScore = 0
         ScoreDisplay.publish(scores[i])
         hasShotMoon = true
         Bus.sharedInstance.send(GameEvent.ShotTheMoon(player.name))
        }
      self.scoresForHand[i] = 0
      }
    return hasShotMoon
    }
    
    /// Has a player gone over a 100 points
    func hasGameBeenWon()
    {
    var lowestScore = 1000
    var winner = -10
    var hasWonGame = false
    var isDraw = false
    
    for i in 0..<self.players.count
      {
      if self.scores[i].currentScore < lowestScore
        {
        lowestScore = self.scores[i].currentScore
        winner = i
        isDraw = false
        } else  if self.scores[i].currentScore == lowestScore
        {
        isDraw = true
        }
    
      if self.scores[i].currentScore >= 100
        {
        hasWonGame = true
        }
      }
    
    let isGameWon = hasWonGame && !isDraw
    if isGameWon
      {
      recordTheScoresForAGameWin(winner)
    
      for (i,_) in scoresForHand.enumerate()
        {
        scoresForHand[i] = 0
        }
      Bus.sharedInstance.send(GameEvent.WinGame(players[winner].name))
      }
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
                    self.scores[winnerIndex].currentScore += score
                    self.scoresForHand[winnerIndex] += score
                    ScoreDisplay.publish(self.scores[winnerIndex])
                }
            }
            
            return winner
            
        }
        return nil
        }
}
    