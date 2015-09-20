//
//  SIdeOfTable.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 15/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//


import SpriteKit

public enum SideOfTable:Int
{
    case Bottom
    case Right
    case Top
    case Left
    case Center
    case TopMidLeft
    case TopMidRight
    
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
            startWidth = width * 0.27
            startheight = height
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .TopMidRight:
            hortizonalSpacing = -width * 0.14 / fullHand
            startWidth = width * 0.73
            startheight = height
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .Left:
            verticalSpacing = -verticalSpacing
            startWidth = width
            startheight = height * 0.6
            return CGPoint(x: -spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            
            // the trick pile
        case .Center:
            let startheight = height * 0.5
            let startWidth = width * 0.35
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.9)
        }
    }
    func rotationOfCard(positionInSpread: CGFloat,fullHand: CGFloat = CGFloat(13)) -> CGFloat
    {
        
    
        
        var startRotate = CGFloat(0)
        switch self
        {
            // Computer Player
        case .Right:
            startRotate = 120.degreesToRadians
            // Computer Player
        case .TopMidLeft:
            fallthrough
        case .TopMidRight:
            fallthrough
        case .Top:
            startRotate = 210.degreesToRadians
            // Computer Player
        case .Left:
            startRotate = -60.degreesToRadians
            // PlayerOne of the trick pile
        default:
            startRotate = 30.degreesToRadians
        }
        
        
        let rotateDelta = 60.degreesToRadians / fullHand
        
        return   startRotate - rotateDelta * positionInSpread
    }
    
    func positionOfWonCards( width: CGFloat, height: CGFloat) -> CGPoint
    {
        
        switch self
        {
            // Player One
        case .Bottom:
            return CGPoint(x: width*0.5,y: -1000.0)
            // Computer Player
        case .Right:
            
            return CGPoint(x: width*2,y: height * 0.5)
            // Computer Player
        case .TopMidLeft:
            
            return CGPoint(x: width*0.1,y: height * 2)
        case .TopMidRight:
            
            return CGPoint(x: width*0.9,y: height * 2)
        case .Top:
            return CGPoint(x: width*0.5,y: height * 2)
            // Computer Player
        case .Left:
            return CGPoint(x: -500,y: height * 0.5)
            
            // the trick pile
        case .Center:
            
            return CGPoint(x: width*0.5,y:  height * 0.5)
            
            
        }
    }
}