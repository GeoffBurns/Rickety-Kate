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
    case Up
    case Left
    case Down
    case Right
    
    
    func rotationOfCard(positionInSpread: CGFloat,fullHand: CGFloat = CardPile.defaultSpread) -> CGFloat
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
