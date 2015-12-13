//
//  Seater.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 23/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//
import SpriteKit


// Where are the players seated
class Seater
{
    static let seatsFor3 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.Left]
    static let seatsFor4 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.Top, SideOfTable.Left]
    static let seatsFor5 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.TopMidRight, SideOfTable.TopMidLeft,
        SideOfTable.Left]
    static let seatsFor5p = [SideOfTable.Bottom,  SideOfTable.RightLow, SideOfTable.RightHigh,  SideOfTable.Top,
        SideOfTable.Left]
    static let seatsFor6 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.TopMidRight, SideOfTable.Top, SideOfTable.TopMidLeft,
        SideOfTable.Left]
    static let seatsFor6p = [SideOfTable.Bottom, SideOfTable.RightLow, SideOfTable.RightHigh, SideOfTable.Top,SideOfTable.LeftHigh, SideOfTable.LeftLow]
    static let seatsFor7 = [SideOfTable.Bottom, SideOfTable.RightLow, SideOfTable.RightHigh, SideOfTable.TopMidRight, SideOfTable.TopMidLeft,SideOfTable.LeftHigh, SideOfTable.LeftLow]
    
    static func seatsFor(noOfPlayers:Int) -> [SideOfTable]
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
    static func portraitSeatsFor(noOfPlayers:Int) -> [SideOfTable]
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
