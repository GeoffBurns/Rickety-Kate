//
//  SIdeOfTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 15/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//


import SpriteKit

// The seating arrangement determines where the players cards and scores are
public enum SideOfTable:Int
{
    case Bottom
    case Right
    case Top
    case Left
    case Center
    case TopMidLeft
    case TopMidRight
    case RightLow
    case RightHigh
    case LeftLow
    case LeftHigh
 
    func positionOfCard(positionInSpread: CGFloat, spriteHeight: CGFloat, width: CGFloat, height: CGFloat, fullHand: CGFloat = CGFloat(13)) -> CGPoint
    {
        var startheight = CGFloat(0.0)
        var startWidth = width * 0.35
 
        var hortizonalSpacing = width * 0.25 / fullHand
        var verticalSpacing = height * 0.18 / fullHand
        let noOfPlayers = GameSettings.sharedInstance.noOfPlayersAtTable
        switch self
        {
            // Player One
        case .Bottom:
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.92)
            // Computer Player
        case .Right:
            startWidth =  GameSettings.isPad ?
                width*0.97 : width
            startheight = height * 0.4
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            // Computer Player        
        case .RightLow:
            startWidth =  GameSettings.isPad ?
                width*0.97 : width
            
            verticalSpacing = height * 0.12 / fullHand
            startheight = height * 0.3
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            // Computer Player        
        case .RightHigh:
            startWidth =  GameSettings.isPad ?
                width*0.97 : width
            
            verticalSpacing = height * 0.12 / fullHand
            startheight = height * 0.65
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            // Computer Player
        case .Top:
            hortizonalSpacing = -width * (noOfPlayers == 6 ? 0.06 : 0.2) / fullHand
            startWidth = width * (noOfPlayers == 6 ? 0.5 : 0.6)
            startheight = GameSettings.isPad ?
                height*1.08 : height
            
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .TopMidLeft:
            hortizonalSpacing = -width * (noOfPlayers == 6  ? 0.06 : 0.14) / fullHand
            startWidth = width * (noOfPlayers == 6 ? 0.20 : 0.33)
            startheight =  GameSettings.isPad ?
                height*1.07 : height

            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .TopMidRight:
            hortizonalSpacing = -width * (noOfPlayers == 6 ? 0.06 : 0.14) / fullHand
            startWidth = width * (noOfPlayers == 6 ? 0.84 : 0.75)
            startheight =  GameSettings.isPad ?
                height*1.07 : height

            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .Left:
            verticalSpacing = -verticalSpacing
            startheight = height * 0.6
            startWidth =  GameSettings.isPad ?
                width*0.03 : 0.0
            return CGPoint(x: startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
        case .LeftLow:
                verticalSpacing = -height * 0.12 / fullHand
                startheight = height * 0.4
                startWidth =  GameSettings.isPad ? width*0.03 : 0.0
                return CGPoint(x: startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
        case .LeftHigh:
                    verticalSpacing = -height * 0.12 / fullHand
                    startheight = height * 0.75
                    startWidth =  GameSettings.isPad ?width*0.03 : 0.0
                    return CGPoint(x: startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            
            // the trick pile
        case .Center:
            let startheight =  GameSettings.isPad ?
            height * 0.5 : height * 0.46
            
            let startWidth = width * 0.35
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.9)
        }
    }
    
    var direction : Direction
    {
        switch self
        {
        case .RightLow:
            fallthrough
        case .RightHigh:
            fallthrough
        case .Right:
            return Direction.Left
        case .TopMidLeft:
            fallthrough
        case .TopMidRight:
            fallthrough
        case .Top:
            return Direction.Down
            
        case .LeftLow:
            fallthrough
        case .LeftHigh:
            fallthrough
        case .Left:
            return Direction.Right

        default:
            return Direction.Up
        }
    }
    func positionOfPassingPile( spriteHeight: CGFloat, width: CGFloat, height: CGFloat) -> CGPoint
    {
        var startheight = CGFloat(0.0)
        var startWidth = width * 0.35
        

        let noOfPlayers = GameSettings.sharedInstance.noOfPlayersAtTable
        switch self
        {
      
            
        case .Right:
            startWidth = width * 0.8
            startheight = height * 0.4
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight)
        case .RightLow:
            startWidth = width * 0.8
            startheight = height * 0.3
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight)
        case .RightHigh:
            startWidth = width * 0.8
            startheight = height * 0.65
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight)
            // Computer Player
        case .Top:
            startWidth = width * 0.6
            startheight = height * 0.8
            return CGPoint(x: startWidth,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .TopMidLeft:
            startWidth = width * (noOfPlayers > 5 ? 0.25 : 0.33)
            startheight = height * 0.8
            return CGPoint(x: startWidth,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .TopMidRight:

            startWidth = width * (noOfPlayers > 5 ? 0.8 : 0.75)
            startheight = height * 0.8
            return CGPoint(x: startWidth,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .Left:
            
            startWidth = width * 0.2
            startheight = height * 0.6
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight )
        case .LeftLow:
            
            startWidth = width * 0.2
            startheight = height * 0.4
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight )
        case .LeftHigh:
            
            startWidth = width * 0.2
            startheight = height * 0.75
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight )
    
            
        default:
            let startheight = height * 0.5
            let startWidth = width * 0.35
            return CGPoint(x: startWidth,y: startheight-spriteHeight*0.9)
        }
    }
    func rotationOfCard(positionInSpread: CGFloat,fullHand: CGFloat = CGFloat(13)) -> CGFloat
    {
        return self.direction.rotationOfCard(positionInSpread, fullHand: fullHand)
    }
   
    func positionOfWonCards( width: CGFloat, height: CGFloat) -> CGPoint
    {
        switch self
        {
            // Player One
        case .Bottom:
            return CGPoint(x: width*0.5,y: -400.0)
            // Computer Player
        case .Right:
            
            return CGPoint(x: width*1.3,y: height * 0.5)
            // Computer Player
        case .RightLow:
            
            return CGPoint(x: width*1.3,y: height * 0.25)
            // Computer Player
        case .RightHigh:
            
            return CGPoint(x: width*1.3,y: height * 0.75)
            // Computer Player
        case .TopMidLeft:
            
            return CGPoint(x: width*0.1,y: height * 1.3)
        case .TopMidRight:
            
            return CGPoint(x: width*0.9,y: height * 1.3)
        case .Top:
            return CGPoint(x: width*0.5,y: height * 1.3)
            // Computer Player
        case .Left:
            return CGPoint(x: -500,y: height * 0.5)
            
        case .LeftLow:
            return CGPoint(x: -500,y: height * 0.25)
            
        case .LeftHigh:
            return CGPoint(x: -500,y: height * 0.75)
            
            // the trick pile
        case .Center:
            
            return CGPoint(x: width*0.5,y:  height * 0.5)
        
            
        }
    }
}