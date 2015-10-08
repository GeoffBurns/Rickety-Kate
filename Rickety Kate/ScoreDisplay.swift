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
    var players = [CardPlayer]()
    

    static let sharedInstance = ScoreDisplay()
    private init() { }
    

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

    func setupScoreFor(scene: SKNode,player:CardPlayer) -> SKLabelNode
        {
            
            let fontsize : CGFloat = GameSettings.isPad ?  20 : (GameSettings.isPhone6Plus ? 42 : 28)

            let l = LabelWithShadow(fontNamed:"Verdana")
            
            l.text = ""
            l.fontSize = fontsize
            l.name = player.name
  
  
            let side = player.sideOfTable
            
   
            l.position = ScoreDisplay.scorePosition(side, scene: scene)
            l.zPosition = 201
            l.zRotation = ScoreDisplay.scoreRotation(side)

            scene.addChild(l)

            l.rac_text <~ combineLatest(player.currentTotalScore.producer, player.noOfWins.producer)
                . map {
                    next in
                    let name = player.name
                    
                    let wins = next.1
                    let score = next.0
                    return (wins==0) ?
                        ((name == "You") ? "Your Score is \(score)" : "\(name)'s Score is \(score)") :
                        ((name == "You") ? "Your Score : \(score) With \(wins) Wins" : "\(name) : \(score) & \(wins) Wins")
                    
            }

            return l
        }
    
  
func setupScoreArea(scene: SKNode, players: [CardPlayer])
{
    scoreLabel  = []

    self.players=players
    for player in players
    {
        scoreLabel.append(setupScoreFor(scene,player:player))
    }
}
}