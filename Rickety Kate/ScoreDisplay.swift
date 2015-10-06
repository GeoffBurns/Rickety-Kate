//
//  ScoreDisplay.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 18/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveCocoa

// Display the score for each player
class ScoreDisplay
{
    var scoreLabel = [SKLabelNode]()
    var scoreLabel2 = [SKLabelNode]()
    var scoreUpdates = [Signal<(Int,Int),NoError>]()
    var scoreSinks : [(Event<(Int,Int), NoError>)->()] = []
    var players = [CardPlayer]()
    lazy var lookup = Dictionary<String,Int>()
    let (scoreSignal, scoreSink) = Signal<Int, NoError>.pipe()
    static let sharedInstance = ScoreDisplay()
    private init() { }
    
    static func publish(player:CardPlayer,score:Int,wins:Int=0)
    {
       let i = ScoreDisplay.sharedInstance.lookup[player.name]
     //   let (signal, sink) = Signal<Int, NoError>.pipe()
//         ScoreDisplay.sharedInstance.scoreUpdates[i!].
        
      let sinks = ScoreDisplay.sharedInstance.scoreSinks
      let sink = sinks[i ?? 0]
      sendNext(sink,(score,wins))
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
            let m = scoreLabel2[i]
            
            
            l.text = ""
            l.fontSize = fontsize
            l.name = "\(player.name)'s score label"
            m.text = ""
            m.fontSize = fontsize
            
            m.fontColor = UIColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 0.7)
  
            let side = player.sideOfTable
            
   
            l.position = ScoreDisplay.scorePosition(side, scene: scene)
            l.zPosition = 301
            l.zRotation = ScoreDisplay.scoreRotation(side)
                
            m.position = CGPoint(x:l.position.x+2,y:l.position.y-2)
            m.zPosition = 299
            m.zRotation = l.zRotation
                
            scene.addChild(l)
            scene.addChild(m)
            
            
            scoreUpdates[i].observeNext { next in
                
            let name = self.players[i].name
                
            let l = self.scoreLabel[i]
            let m = self.scoreLabel2[i]
            let wins = next.1
            let message = (wins==0) ?
                    ((name == "You") ? "Your Score is \(next.0)" : "\(name)'s Score is \(next.0)") :
                    ((name == "You") ? "Your Score : \(next.0) With \(wins) Wins" : "\(name) : \(next.0) & \(wins) Wins")
            l.text = message
            m.text = message
            }
            
            
            sendNext(scoreSinks[i],(0,0))
        }
    
  
func setupScoreArea(scene: SKNode, players: [CardPlayer])
{
    scoreUpdates = []
    scoreLabel  = []
    scoreLabel2  = []
    var i = 0
    self.players=players
    for player in players
    {
        let (scoreSignal, scoreSink) = Signal<(Int,Int), NoError>.pipe()
        scoreUpdates.append(scoreSignal)
        
        scoreSinks.append(scoreSink)
        scoreLabel.append(SKLabelNode(fontNamed:"Verdana"))
        scoreLabel2.append(SKLabelNode(fontNamed:"Verdana"))
        lookup.updateValue(i, forKey: player.name)
        setupScoreFor(scene,i:i)
        i++
    }
}
}