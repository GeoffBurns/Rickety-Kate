//
//  ScoreDisplay.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 18/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit
import ReactiveCocoa
import ReactiveSwift


// Display the score for each player
class ScoreDisplay
{
    var scoreLabel = [SKLabelNode]()
    var players = [CardPlayer]()
    
    static let sharedInstance = ScoreDisplay()
    fileprivate init() { }
    
    static func register(_ scene: SKNode, players: [CardPlayer])
    {
        ScoreDisplay.sharedInstance.setupScoreArea(scene, players: players)
    }
    
    static func scorePosition(_ side:SideOfTable, size: CGSize, bannerHeight:CGFloat) -> CGPoint
    {
    let top : CGFloat =  DeviceSettings.isPortrait ? 0.90 : 0.87
        let bottom : CGFloat =  DeviceSettings.isPortrait ? 0.12 :
                                    (DeviceSettings.isPhone
                                        ? (DeviceSettings.isPhoneX ? 0.25 : 0.19)
                                        : 0.22)
        
    let noOfPlayers = GameSettings.sharedInstance.noOfPlayersAtTable
    switch side
      {
      case .right:
        return CGPoint(x:size.width * 0.93, y:size.height * 0.5 + bannerHeight)
      case .rightLow:
        return CGPoint(x:size.width * 0.93, y:size.height * 0.35 + bannerHeight)
      case .rightHigh:
        return CGPoint(x:size.width * 0.93, y:size.height * 0.70 + bannerHeight)
       case .top:
        return  CGPoint(x:size.width * 0.5, y:size.height *  top + bannerHeight)
       case .topMidRight:
        return CGPoint(x:size.width * ( noOfPlayers == 6 ? 0.8 : 0.7), y:size.height *  top  + bannerHeight)
       case .topMidLeft:
          return CGPoint(x:size.width *  ( noOfPlayers == 6 ? 0.2 : 0.3), y:size.height *  top + bannerHeight)
       case .left:
        return CGPoint(x:size.width * 0.07, y:size.height * 0.5 + bannerHeight)
      case .leftLow:
        return CGPoint(x:size.width * 0.07, y:size.height * 0.35 + bannerHeight)
      case .leftHigh:
        return CGPoint(x:size.width * 0.07, y:size.height * 0.70 + bannerHeight)
       default:
          return  CGPoint(x:size.width * 0.5, y:size.height *  bottom + bannerHeight)
       }
    }
    
    static func scoreRotation(_ side:SideOfTable) -> CGFloat
    {
        switch side
        {
        case .rightHigh:
            fallthrough
        case .rightLow:
            fallthrough
        case .right:
            return 90.degreesToRadians
        case .top:
            fallthrough
        case .topMidRight:
            fallthrough
        case .topMidLeft:
               return 0.degreesToRadians
        case .leftHigh:
            fallthrough
        case .leftLow:
            fallthrough
        case .left:
               return -90.degreesToRadians
        default:
               return  0.degreesToRadians
        }
    }

    func setupScoreFor(_ scene: SKNode,player:CardPlayer) -> SKLabelNode
        {
            
            let fontsize : CGFloat = FontSize.smaller.scale

            let l = Label(fontNamed:"Verdana").withShadow()
            
            l.text = ""
            l.fontSize = fontsize
            l.name = player.name
  
            let side = player.sideOfTable
            
       //     l.position = ScoreDisplay.scorePosition(side, scene: scene)
            l.zPosition = 201
            l.zRotation = ScoreDisplay.scoreRotation(side)

            scene.addChild(l)

            l.rac_text <~ SignalProducer.combineLatest(player.currentTotalScore.producer, player.noOfWins.producer)
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
    
  
func setupScoreArea(_ scene: SKNode, players: [CardPlayer])
{
    scoreLabel  = []

    self.players=players
    for player in players
    {
        scoreLabel.append(setupScoreFor(scene,player:player))
    }
}
}
