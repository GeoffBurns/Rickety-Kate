//
//  ScoreDisplay.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 18/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveCocoa


struct Score
{
    var currentScore = 0
    var totalWins = 0
    
}
// Display the score for each player
class ScoreDisplay
{
    var scoreLabel = [SKLabelNode]()
    var scoreUpdates = [Signal<Score,NoError>]()
    var scoreSinks : [(Event<Score, NoError>)->()] = []
    var players = [CardPlayer]()
    lazy var lookup = Dictionary<String,Int>()
    static let sharedInstance = ScoreDisplay()
    private init() { }
    
    static func publish(player:CardPlayer,score:Int,wins:Int=0)
    {
       let i = ScoreDisplay.sharedInstance.lookup[player.name]
     //   let (signal, sink) = Signal<Int, NoError>.pipe()
//         ScoreDisplay.sharedInstance.scoreUpdates[i!].
        
      let sinks = ScoreDisplay.sharedInstance.scoreSinks
      let sink = sinks[i ?? 0]
      sendNext(sink,Score(currentScore: score, totalWins: wins))
    }
    
    static func register(scene: SKNode, players: [CardPlayer])
    {
        ScoreDisplay.sharedInstance.setupScoreArea(scene, players: players)
    }
    
    static func scorePosition(side:SideOfTable, scene: SKNode) -> CGPoint
    {
        
        let noOfPlayers = GameSettings.sharedInstance.noOfPlayersAtTable
      switch side
      {
      case .Right:
        return CGPoint(x:scene.frame.size.width * 0.93, y:CGRectGetMidY(scene.frame))
      case .RightLow:
        return CGPoint(x:scene.frame.size.width * 0.93, y:scene.frame.size.height * 0.35)
      case .RightHigh:
        return CGPoint(x:scene.frame.size.width * 0.93, y:scene.frame.size.height * 0.70)
       case .Top:
        return  CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height *  0.87 )
       case .TopMidRight:
        return CGPoint(x:scene.frame.width * ( noOfPlayers == 6 ? 0.8 : 0.7), y:scene.frame.size.height *  0.87 )
       case .TopMidLeft:
          return CGPoint(x:scene.frame.width *  ( noOfPlayers == 6 ? 0.2 : 0.3), y:scene.frame.size.height *  0.87)
       case .Left:
        return CGPoint(x:scene.frame.size.width * 0.07, y:CGRectGetMidY(scene.frame))
      case .LeftLow:
        return CGPoint(x:scene.frame.size.width * 0.07, y:scene.frame.size.height * 0.35)
      case .LeftHigh:
        return CGPoint(x:scene.frame.size.width * 0.07, y:scene.frame.size.height * 0.70)
       default:
          return  CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height *  0.27)
       }
    }
    
    static func scoreRotation(side:SideOfTable) -> CGFloat
    {
        switch side
        {
        case .RightHigh:
            fallthrough
        case .RightLow:
            fallthrough
        case .Right:
            return 90.degreesToRadians
        case .Top:
            fallthrough
        case .TopMidRight:
            fallthrough
        case .TopMidLeft:
               return 0.degreesToRadians
        case .LeftHigh:
            fallthrough
        case .LeftLow:
            fallthrough
        case .Left:
               return -90.degreesToRadians
        default:
               return  0.degreesToRadians
        }
    }

   func setupScoreFor(scene: SKNode,i:Int)
        {
            
            let fontsize : CGFloat = GameSettings.isPad ?  20 : (GameSettings.isPhone6Plus ? 42 : 28)
            let player = players[i]
            let l = scoreLabel[i]
 
            
            
            l.text = ""
            l.fontSize = fontsize
            l.name = "\(player.name)'s score label"
  
  
            let side = player.sideOfTable
            
   
            l.position = ScoreDisplay.scorePosition(side, scene: scene)
            l.zPosition = 301
            l.zRotation = ScoreDisplay.scoreRotation(side)
                
         
            scene.addChild(l)
            
            
            
            scoreUpdates[i].observeNext { next in
                
            let name = self.players[i].name
                
            let l = self.scoreLabel[i]

            let wins = next.totalWins
            let score = next.currentScore
            let message = (wins==0) ?
                    ((name == "You") ? "Your Score is \(score)" : "\(name)'s Score is \(score)") :
                    ((name == "You") ? "Your Score : \(score) With \(wins) Wins" : "\(name) : \(score) & \(wins) Wins")
            l.text = message

            }
               sendNext(scoreSinks[i],Score())
        }
    
  
func setupScoreArea(scene: SKNode, players: [CardPlayer])
{
    scoreUpdates = []
    scoreLabel  = []

    var i = 0
    self.players=players
    for player in players
    {
        let (scoreSignal, scoreSink) = Signal<Score, NoError>.pipe()
        scoreUpdates.append(scoreSignal)
        
        scoreSinks.append(scoreSink)
        scoreLabel.append(LabelWithShadow(fontNamed:"Verdana"))

        lookup.updateValue(i, forKey: player.name)
        setupScoreFor(scene,i:i)
        i++
    }
}
}