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
    
    func positionOfCard(positionInSpread: CGFloat, spriteHeight: CGFloat, width: CGFloat, height: CGFloat) -> CGPoint
    {
        var startheight = CGFloat(0.0)
        var startWidth = width * 0.35
        var fullHand = CGFloat(13)
        var hortizonalSpacing = width * 0.3 / fullHand
        var verticalSpacing = height * 0.2 / fullHand
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
        case .Left:
            verticalSpacing = -verticalSpacing
            startWidth = width
            startheight = height * 0.6
            return CGPoint(x: -spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            
            // the trick pile
        case .Center:
            var startheight = height * 0.5
            var startWidth = width * 0.35
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.9)
        }
    }
    func rotationOfCard(positionInSpread: CGFloat) -> CGFloat
    {
        
        var fullHand = CGFloat(13)
        
        var startRotate = CGFloat(0)
        switch self
        {
            // Computer Player
        case .Right:
            startRotate = 120.degreesToRadians
            // Computer Player
        case .Top:
            startRotate = 210.degreesToRadians
            // Computer Player
        case .Left:
            startRotate = -60.degreesToRadians
            // PlayerOne of the trick pile
        default:
            startRotate = 30.degreesToRadians
        }
        
        
        var rotateDelta = 60.degreesToRadians / fullHand
        
        return   startRotate - rotateDelta * positionInSpread
    }
    
    func positionOfWonCards( width: CGFloat, height: CGFloat) -> CGPoint
    {
        
        switch self
        {
            // Player One
        case .Bottom:
            return CGPoint(x: width*0.5,y: -200.0)
            // Computer Player
        case .Right:
            
            return CGPoint(x: width*1.2,y: height * 0.5)
            // Computer Player
        case .Top:
            return CGPoint(x: width*0.5,y: height * 1.2)
            // Computer Player
        case .Left:
            return CGPoint(x: -200,y: height * 0.5)
            
            // the trick pile
        case .Center:
            
            return CGPoint(x: width*0.5,y:  height * 0.5)
            
            
        }
    }
}