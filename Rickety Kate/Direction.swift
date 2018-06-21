//
//  Direction.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 24/09/2015.
//  Copyright © Geoff Burns. All rights reserved.
//


import SpriteKit


/// Which direction are the cards and scores rotated
public enum Direction:Int
{
    case up
    case left
    case down
    case right
    
    
    func rotationOfCard(_ positionInSpread: CGFloat,fullHand: CGFloat = CardPile.defaultSpread) -> CGFloat
    {
        var startRotate = CGFloat(0)
        switch self
        {
        case .left:
            startRotate = 120.degreesToRadians
        case .down:
            startRotate = 210.degreesToRadians
        case .right:
            startRotate = -60.degreesToRadians
        default:
            startRotate = 30.degreesToRadians
        }
        
        let rotateDelta = 60.degreesToRadians / fullHand
        
        return   startRotate - rotateDelta * positionInSpread
    }
    
    func positionOfCard(_ positionInSpread: CGFloat, spriteHeight: CGFloat, startWidth: CGFloat, startheight: CGFloat, hortizonalSpacing: CGFloat, verticalSpacing: CGFloat) -> CGPoint
    {
        
        switch self
        {
        case .up:
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.92)
            
        case .left:
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            
        case .down:
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            
        case .right:
            
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
        }
    }
}
