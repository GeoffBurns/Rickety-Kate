//
//  ScoreDisplay.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 18/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation
import SpriteKit


class ScoreDisplay
{
    var scoreLabel : [SKLabelNode] = []
//    var scoreLabel2 = [SKLabelNode](count: 4, repeatedValue: SKLabelNode())
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

        func setupScoreFor(scene: SKNode,i:Int)
        {
        
            // having problems setting font color
            //   scoreLabel2[i] = SKLabelNode(fontNamed:"Verdana")
            
            let l = scoreLabel[i]
            //     let m = scoreLabel2[i]
            
            scoreUpdates[i] = Publink<(Int,Int)>()
            
            l.text = ""
            l.fontSize = 30;
            l.name = "\(players[i].name)'s score label"
            //    m.text = ""
            //    m.fontSize = 30;
            
            //   m.color = UIColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 0.7)
            //   m.color = UIColor.blackColor()
            //   m.colorBlendFactor = 1.0
            
            if let side = SideOfTable(rawValue: i)
            {
                var position = CGPoint()
                var rotate = CGFloat()
                switch side
                {
                case .Right:
                    position = CGPoint(x:scene.frame.size.width * 0.90, y:CGRectGetMidY(scene.frame))
                    rotate = 90.degreesToRadians
                case .Top:
                    position = CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.75)
                    rotate = 0.degreesToRadians
                case .Left:
                    position = CGPoint(x:scene.frame.size.width * 0.10, y:CGRectGetMidY(scene.frame))
                    rotate = -90.degreesToRadians
                default:
                    position = CGPoint(x:CGRectGetMidX(scene.frame), y:scene.frame.size.height * 0.35)
                    rotate = 0.degreesToRadians
                }
                
                l.position = position
                l.zPosition = 301
                l.zRotation = rotate
                
                //      m.position = CGPoint(x:position.x+2,y:position.y-2)
                //      m.zPosition = 299
                //      m.zRotation = rotate
                
                scene.addChild(l)
                //       self.addChild(m)
            }
            
            scoreUpdates[i].subscribe() { (update:(Int,Int)) in
                
                let name = self.players[i].name
                
                let l = self.scoreLabel[i]
                //         let m = self.scoreLabel2[i]
                let wins = update.1
                let message = (wins==0) ?
                    ((name == "You") ? "Your Score is \(update.0)" : "\(name)'s Score is \(update.0)") :
                    ((name == "You") ? "Your Score : \(update.0) With \(wins) Wins" : "\(name)'s Score : \(update.0) With \(wins) Wins")
                l.text = message
                //    m.text = message
            }
            
            scoreUpdates[i].publish((0,0))
            
        }
    
  
func setupScoreArea(scene: SKNode, players: [CardPlayer])
{
    scoreUpdates = []
    scoreLabel  = []
    var i = 0
    self.players=players
    for player in players
    {
        scoreUpdates.append(Publink<(Int,Int)>())
        scoreLabel.append(SKLabelNode(fontNamed:"Verdana"))
        lookup.updateValue(i, forKey: player.name)
        setupScoreFor(scene,i:i)
        i++
    }
}
}