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
    case bottom
    case right
    case top
    case left
    case center
    case topMidLeft
    case topMidRight
    case rightLow
    case rightHigh
    case leftLow
    case leftHigh
 
    fileprivate func heightOfFarHand(_ height: CGFloat, _ top: CGFloat) -> CGFloat {
        if DeviceSettings.isPhone
          {
            return height * top + height * -0.03
        }
  
        if DeviceSettings.isPortrait
        {
            
            return height * top + height * (height > 1200 /* iPadPro */ ? 0.018 : 0.033)
        }
        
      
            return height * top + height * (height > 870 /* iPadPro */ ?  -0.06 : -0.03 )

    }
    
    func positionOfCard(_ positionInSpread: CGFloat, spriteHeight: CGFloat, width: CGFloat, height: CGFloat, fullHand: CGFloat = CardPile.defaultSpread) -> CGPoint
    {
        var startheight = CGFloat(0.0)
        var startWidth = width * 0.35
 
        var hortizonalSpacing = width * 0.25 / fullHand
        var verticalSpacing = height * 0.18 / fullHand
        let noOfPlayers = GameSettings.sharedInstance.noOfPlayersAtTable
        let top : CGFloat = DeviceSettings.isPortrait ? 1.0 : 1.09
        switch self
        {
            // Player One
        case .bottom:
       
            startheight = height * (DeviceSettings.isPortrait ? -0.022 : -0.02)
            let heightfactor : CGFloat = DeviceSettings.isPad ? 0.92 : 1.05
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread, y: startheight-spriteHeight * heightfactor )
            // Computer Player
        case .right:
            startWidth =  width*0.96
            startheight = height * 0.4
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            // Computer Player        
        case .rightLow:
            startWidth = width*0.96
            
            verticalSpacing = height * 0.12 / fullHand
            startheight = height * 0.3
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            // Computer Player        
        case .rightHigh:
            startWidth = width*0.96
            
            verticalSpacing = height * 0.12 / fullHand
            startheight = height * 0.65
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            // Computer Player
        case .top:
            hortizonalSpacing = -width * (noOfPlayers == 6 ? 0.06 : 0.2) / fullHand
            startWidth = width * (noOfPlayers == 6 ? 0.5 : 0.6)
            startheight = heightOfFarHand(height, top)
            
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .topMidLeft:
            hortizonalSpacing = -width * (noOfPlayers == 6  ? 0.06 : 0.14) / fullHand
            startWidth = width * (noOfPlayers == 6 ? 0.20 : 0.33)

            startheight = heightOfFarHand(height, top)

            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .topMidRight:
            hortizonalSpacing = -width * (noOfPlayers == 6 ? 0.06 : 0.14) / fullHand
            startWidth = width * (noOfPlayers == 6 ? 0.84 : 0.75)
    
            startheight = heightOfFarHand(height, top)

            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .left:
            verticalSpacing = -verticalSpacing
            startheight = height * 0.6
            startWidth =
                width*0.04
            return CGPoint(x: startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
        case .leftLow:
                verticalSpacing = -height * 0.12 / fullHand
                startheight = height * 0.4
                startWidth =   width*0.04
                return CGPoint(x: startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
        case .leftHigh:
                    verticalSpacing = -height * 0.12 / fullHand
                    startheight = height * 0.75
                    
                    startWidth =   width*0.04
                 //   startWidth =  DeviceSettings.isPad ? width*0.03 : 0.01
                    return CGPoint(x: startWidth - spriteHeight*1.4 ,y: startheight+verticalSpacing*positionInSpread )
            
            // the trick pile
        case .center:
            let startheight =  DeviceSettings.isPad ?
            height * 0.5 : height * 0.46
            
            let startWidth = width * 0.35
            return CGPoint(x: startWidth+hortizonalSpacing*positionInSpread,y: startheight-spriteHeight*0.9)
        }
    }
    
    var direction : Direction
    {
        switch self
        {
        case .rightLow:
            fallthrough
        case .rightHigh:
            fallthrough
        case .right:
            return Direction.left
        case .topMidLeft:
            fallthrough
        case .topMidRight:
            fallthrough
        case .top:
            return Direction.down
            
        case .leftLow:
            fallthrough
        case .leftHigh:
            fallthrough
        case .left:
            return Direction.right

        default:
            return Direction.up
        }
    }
    func positionOfPassingPile( _ spriteHeight: CGFloat, width: CGFloat, height: CGFloat) -> CGPoint
    {
        var startheight = CGFloat(0.0)
        var startWidth = width * 0.35
        

        let noOfPlayers = GameSettings.sharedInstance.noOfPlayersAtTable
        switch self
        {
      
            
        case .right:
            startWidth = width * 0.8
            startheight = height * 0.4
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight)
        case .rightLow:
            startWidth = width * 0.8
            startheight = height * 0.3
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight)
        case .rightHigh:
            startWidth = width * 0.8
            startheight = height * 0.65
            return CGPoint(x: startWidth+spriteHeight*1.4 ,y: startheight)
            // Computer Player
        case .top:
            startWidth = width * 0.6
            startheight = height * 0.8
            return CGPoint(x: startWidth,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .topMidLeft:
            startWidth = width * (noOfPlayers > 5 ? 0.25 : 0.33)
            startheight = height * 0.8
            return CGPoint(x: startWidth,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .topMidRight:

            startWidth = width * (noOfPlayers > 5 ? 0.8 : 0.75)
            startheight = height * 0.8
            return CGPoint(x: startWidth,y: startheight+spriteHeight*0.65)
            // Computer Player
        case .left:
            
            startWidth = width * 0.2
            startheight = height * 0.6
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight )
        case .leftLow:
            
            startWidth = width * 0.2
            startheight = height * 0.4
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight )
        case .leftHigh:
            
            startWidth = width * 0.2
            startheight = height * 0.75
            return CGPoint(x:startWidth - spriteHeight*1.4 ,y: startheight )
    
            
        default:
            let startheight = height * 0.5
            let startWidth = width * 0.35
            return CGPoint(x: startWidth,y: startheight-spriteHeight*0.9)
        }
    }
    func rotationOfCard(_ positionInSpread: CGFloat,fullHand: CGFloat = CardPile.defaultSpread) -> CGFloat
    {
        return self.direction.rotationOfCard(positionInSpread, fullHand: fullHand)
    }
   
    func positionOfWonCards( _ width: CGFloat, height: CGFloat) -> CGPoint
    {
        switch self
        {
            // Player One
        case .bottom:
            return CGPoint(x: width*0.5,y: -400.0)
            // Computer Player
        case .right:
            
            return CGPoint(x: width*1.3,y: height * 0.5)
            // Computer Player
        case .rightLow:
            
            return CGPoint(x: width*1.3,y: height * 0.25)
            // Computer Player
        case .rightHigh:
            
            return CGPoint(x: width*1.3,y: height * 0.75)
            // Computer Player
        case .topMidLeft:
            
            return CGPoint(x: width*0.1,y: height * 1.3)
        case .topMidRight:
            
            return CGPoint(x: width*0.9,y: height * 1.3)
        case .top:
            return CGPoint(x: width*0.5,y: height * 1.3)
            // Computer Player
        case .left:
            return CGPoint(x: -500,y: height * 0.5)
            
        case .leftLow:
            return CGPoint(x: -500,y: height * 0.25)
            
        case .leftHigh:
            return CGPoint(x: -500,y: height * 0.75)
            
            // the trick pile
        case .center:
            
            return CGPoint(x: width*0.5,y:  height * 0.5)
        
            
        }
    }
}
