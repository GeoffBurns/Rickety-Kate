//
//  ScoreDisplay.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 18/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit


class ScoreDisplay
{
    var scoreLabel : [SKLabelNode] = []
    var scoreLabel2 : [SKLabelNode] = []
    var scoreUpdates : [Publink<(Int,Int)>] = []
    
    var players : [CardPlayer] = []
    var lookup : Dictionary<String,Int> = [:]
    static let sharedInstance = ScoreDisplay()
    private init() { }
    
    static func publish(player:CardPlayer,score:Int,wins:Int=0)
    {
        let i = ScoreDisplay.sharedInstance.lookup[player.name]
        ScoreDisplay.sharedInstance.scoreUpdates[i!].publish(score,wins)
    }
    
    static func register(scene: SKNode, players: [CardPlayer])
    {
        ScoreDisplay.sharedInstance.setupScoreArea(scene, players: players)
    }
    
    static func scorePosition(side:SideOfTable, scene: SKNode) -> CGPoint
    {
      switch side
       {
       case .Right:
          return CGPoint(x:scene.frame.size.width * 0.90, y:CGRectGetMidY(scene.frame))
       case .Top:
          return  CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.75)
       case .TopMidRight:
          return CGPoint(x:scene.frame.width * 0.8, y:scene.frame.size.height * 0.75)
       case .TopMidLeft:
          return CGPoint(x:scene.frame.width * 0.2, y:scene.frame.size.height * 0.75)
       case .Left:
          return CGPoint(x:scene.frame.size.width * 0.10, y:CGRectGetMidY(scene.frame))
       default:
          return  CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.35)
       }
    }
    
    static func scoreRotation(side:SideOfTable) -> CGFloat
    {
        switch side
        {
        case .Right:
            return 90.degreesToRadians
        case .Top:
            return 0.degreesToRadians
        case .TopMidRight:
               return  0.degreesToRadians
        case .TopMidLeft:
               return 0.degreesToRadians
        case .Left:
               return -90.degreesToRadians
        default:
               return  0.degreesToRadians
        }
    }

   func setupScoreFor(scene: SKNode,i:Int)
        {
            let player = players[i]
            let l = scoreLabel[i]
            let m = scoreLabel2[i]
            
            scoreUpdates[i] = Publink<(Int,Int)>()
            
            l.text = ""
            l.fontSize = 30;
            l.name = "\(player.name)'s score label"
            m.text = ""
            m.fontSize = 30;
            
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
            
            
            scoreUpdates[i].subscribe() { (update:(Int,Int)) in
                
            let name = self.players[i].name
                
            let l = self.scoreLabel[i]
            let m = self.scoreLabel2[i]
            let wins = update.1
            let message = (wins==0) ?
                    ((name == "You") ? "Your Score is \(update.0)" : "\(name)'s Score is \(update.0)") :
                    ((name == "You") ? "Your Score : \(update.0) With \(wins) Wins" : "\(name) : \(update.0) & \(wins) Wins")
            l.text = message
            m.text = message
            }
            
            scoreUpdates[i].publish((0,0))
            
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
        scoreUpdates.append(Publink<(Int,Int)>())
        scoreLabel.append(SKLabelNode(fontNamed:"Verdana"))
        scoreLabel2.append(SKLabelNode(fontNamed:"Verdana"))
        lookup.updateValue(i, forKey: player.name)
        setupScoreFor(scene,i:i)
        i++
    }
}
}