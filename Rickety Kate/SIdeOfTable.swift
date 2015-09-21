//
//  SIdeOfTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 15/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//


import SpriteKit

public enum Direction:Int
{
    case Up
    case Left
    case Down
    case Right
    
    
    func rotationOfCard(positionInSpread: CGFloat,fullHand: CGFloat = CGFloat(13)) -> CGFloat
    {
        var startRotate = CGFloat(0)
        switch self
        {
        case .Left:
            startRotate = 120.degreesToRadians
        case .Down:
            startRotate = 210.degreesToRadians
        case .Right:
            startRotate = -60.degreesToRadians
        default:
            startRotate = 30.degreesToRadians
        }
        
        let rotateDelta = 60.degreesToRadians / fullHand
        
        return   startRotate - rotateDelta * positionInSpread
    }
    func positionOfCard(positionInSpread: CGFloat, spriteHeight: CGFloat, startWidth: CGFloat, startheight: CGFloat, hortizonalSpacing: CGFloat, verticalSpacing: CGFloat) -> CGPoint
    {
    
        switch self
        {
        case .Up:
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.92)
           
        case .Left:
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            
        case .Down:
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            
        case .Right:
            
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
        }
    }
}

public enum SideOfTable:Int
{
    case Bottom
    case Right
    case Top
    case Left
    case Center
    case TopMidLeft
    case TopMidRight
    case CenterRight
    case CenterLeft
    case CenterTop
    case CenterTopMidRight
    case CenterTopMidLeft
 
    func positionOfCard(positionInSpread: CGFloat, spriteHeight: CGFloat, width: CGFloat, height: CGFloat, fullHand: CGFloat = CGFloat(13)) -> CGPoint
    {
        var startheight = CGFloat(0.0)
        var startWidth = width * 0.35
 
        var hortizonalSpacing = width * 0.25 / fullHand
        var verticalSpacing = height * 0.18 / fullHand
        switch self
        {
            // Player One
        case .Bottom:
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.92)
            // Computer Player
        case .Right:
            startWidth = width
            startheight = height * 0.4
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            // Computer Player
        case .Top:
            hortizonalSpacing = -width * 0.2 / fullHand
            startWidth = width * 0.6
            startheight = height
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .TopMidLeft:
            hortizonalSpacing = -width * 0.14 / fullHand
            startWidth = width * 0.33
            startheight = height
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .TopMidRight:
            hortizonalSpacing = -width * 0.14 / fullHand
            startWidth = width * 0.75
            startheight = height
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .Left:
            verticalSpacing = -verticalSpacing
            startheight = height * 0.6
            return CGPoint(x: -spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            
            // the trick pile
        case .Center:
            let startheight = height * 0.5
            let startWidth = width * 0.35
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.9)
            
        case .CenterRight:
            startWidth = width * 0.8
            startheight = height * 0.4
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            // Computer Player
        case .CenterTop:
            hortizonalSpacing = -width * 0.2 / fullHand
            startWidth = width * 0.6
            startheight = height * 0.8
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .CenterTopMidLeft:
            hortizonalSpacing = -width * 0.14 / fullHand
            startWidth = width * 0.33
            startheight = height * 0.8
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .CenterTopMidRight:
            hortizonalSpacing = -width * 0.14 / fullHand
            startWidth = width * 0.75
            startheight = height * 0.8
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .CenterLeft:
            verticalSpacing = -verticalSpacing
            startWidth = width * 0.2
            startheight = height * 0.6
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
        }
    }
    
    var direction : Direction
    {
        switch self
        {
        case .CenterRight:
            fallthrough
        case .Right:
            return Direction.Left
            
        case .TopMidLeft:
            fallthrough
        case .TopMidRight:
            fallthrough
        case .CenterTop:
            fallthrough
        case .CenterTopMidRight:
            fallthrough
        case .CenterTopMidLeft:
            fallthrough
        case .Top:
            return Direction.Down
            
        case .CenterLeft:
            fallthrough
        case .Left:
            
            return Direction.Right
        default:
            
            return Direction.Up
        }
    }
    
    func rotationOfCard(positionInSpread: CGFloat,fullHand: CGFloat = CGFloat(13)) -> CGFloat
    {
        return self.direction.rotationOfCard(positionInSpread, fullHand: fullHand)
    }
    
    var center: SideOfTable
    {
        switch self
        {
            // Computer Player
        case .Right:
            return .CenterRight
            // Computer Player
        case .TopMidLeft:
            
            return .CenterTopMidLeft
        case .TopMidRight:
            
            return .CenterTopMidRight
        case .Top:
            
            return .CenterTop
            // Computer Player
        case .Left:
            return .CenterLeft
            // PlayerOne of the trick pile
        default:
            return .Center
        }
        
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
        case .TopMidLeft:
            
            return CGPoint(x: width*0.1,y: height * 1.3)
        case .TopMidRight:
            
            return CGPoint(x: width*0.9,y: height * 1.3)
        case .Top:
            return CGPoint(x: width*0.5,y: height * 1.3)
            // Computer Player
        case .Left:
            return CGPoint(x: -500,y: height * 0.5)
            
            // the trick pile
        case .Center:
            
            return CGPoint(x: width*0.5,y:  height * 0.5)
        default:
            return CGPoint(x: width*0.5,y: -400.0)
            
        }
    }
}