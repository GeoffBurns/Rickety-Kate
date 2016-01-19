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
    
    static func scorePosition(side:SideOfTable, size: CGSize, bannerHeight:CGFloat) -> CGPoint
    {
    let top : CGFloat =  DeviceSettings.isPortrait ? 0.85 : 0.87
    let bottom : CGFloat =  DeviceSettings.isPortrait ? 0.18 : 0.27
        
    let noOfPlayers = GameSettings.sharedInstance.noOfPlayersAtTable
    switch side
      {
      case .Right:
        return CGPoint(x:size.width * 0.93, y:size.height * 0.5 + bannerHeight)
      case .RightLow:
        return CGPoint(x:size.width * 0.93, y:size.height * 0.35 + bannerHeight)
      case .RightHigh:
        return CGPoint(x:size.width * 0.93, y:size.height * 0.70 + bannerHeight)
       case .Top:
        return  CGPoint(x:size.width * 0.5, y:size.height *  top + bannerHeight)
       case .TopMidRight:
        return CGPoint(x:size.width * ( noOfPlayers == 6 ? 0.8 : 0.7), y:size.height *  top  + bannerHeight)
       case .TopMidLeft:
          return CGPoint(x:size.width *  ( noOfPlayers == 6 ? 0.2 : 0.3), y:size.height *  top + bannerHeight)
       case .Left:
        return CGPoint(x:size.width * 0.07, y:size.height * 0.5 + bannerHeight)
      case .LeftLow:
        return CGPoint(x:size.width * 0.07, y:size.height * 0.35 + bannerHeight)
      case .LeftHigh:
        return CGPoint(x:size.width * 0.07, y:size.height * 0.70 + bannerHeight)
       default:
          return  CGPoint(x:size.width * 0.5, y:size.height *  bottom + bannerHeight)
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
            
            let fontsize : CGFloat = FontSize.Smaller.scale

            let l = Label(fontNamed:"Verdana").withShadow()
            
            l.text = ""
            l.fontSize = fontsize
            l.name = player.name
  
            let side = player.sideOfTable
            
       //     l.position = ScoreDisplay.scorePosition(side, scene: scene)
            l.zPosition = 201
            l.zRotation = ScoreDisplay.scoreRotation(side)

            scene.addChild(l)

            l.rac_text <~ combineLatest(player.currentTotalScore.producer, player.noOfWins.producer)
                . map {
                    next in
                    let name = player.name
                    
                    let wins = next.1
                    let score = next.0
                    
                    if wins==0
                    {
                       return  "%@ score is %d".with.sayTo(name).using(score).localize
                    }
                    
                    return "%@ Score %d n %d %@".with.sayTo(name).using(score).pluralizeUnit(wins, unit: "Win").localize
    
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