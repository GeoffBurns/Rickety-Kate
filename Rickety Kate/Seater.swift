//
//  Seater.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 23/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//
import SpriteKit
import Cards

// Where are the players seated
class Seater
{
    static let seatsFor3 = [SideOfTable.bottom, SideOfTable.right, SideOfTable.left]
    static let seatsFor4 = [SideOfTable.bottom, SideOfTable.right, SideOfTable.top, SideOfTable.left]
    static let seatsFor5 = [SideOfTable.bottom, SideOfTable.right, SideOfTable.topMidRight, SideOfTable.topMidLeft,
        SideOfTable.left]
    static let seatsFor5p = [SideOfTable.bottom,  SideOfTable.rightLow, SideOfTable.rightHigh,  SideOfTable.top,
        SideOfTable.left]
    static let seatsFor6 = [SideOfTable.bottom, SideOfTable.right, SideOfTable.topMidRight, SideOfTable.top, SideOfTable.topMidLeft,
        SideOfTable.left]
    static let seatsFor6p = [SideOfTable.bottom, SideOfTable.rightLow, SideOfTable.rightHigh, SideOfTable.top,SideOfTable.leftHigh, SideOfTable.leftLow]
    static let seatsFor7 = [SideOfTable.bottom, SideOfTable.rightLow, SideOfTable.rightHigh, SideOfTable.topMidRight, SideOfTable.topMidLeft,SideOfTable.leftHigh, SideOfTable.leftLow]
    
    static func seatsFor(_ noOfPlayers:Int) -> [SideOfTable]
    {
        switch noOfPlayers
        {
        case 3 : return seatsFor3
        case 4 : return seatsFor4
        case 5 : return seatsFor5
        case 6 : return seatsFor6
        case 7 : return seatsFor7
        default : return []
        }
    }
    static func portraitSeatsFor(_ noOfPlayers:Int) -> [SideOfTable]
    {
        switch noOfPlayers
        {
        case 3 : return seatsFor3
        case 4 : return seatsFor4
        case 5 : return seatsFor5p
        case 6 : return seatsFor6p
        case 7 : return seatsFor7
        default : return []
        }
    }
    
}
