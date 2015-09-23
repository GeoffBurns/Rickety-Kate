//
//  Seater.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 23/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//
import SpriteKit

class Seater
{
    static let seatsFor3 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.Left]
    static let seatsFor4 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.Top, SideOfTable.Left]
    static let seatsFor5 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.TopMidRight, SideOfTable.TopMidLeft,
        SideOfTable.Left]
    
    static let seatsFor6 = [SideOfTable.Bottom, SideOfTable.Right, SideOfTable.TopMidRight, SideOfTable.Top, SideOfTable.TopMidLeft,
        SideOfTable.Left]
    
    static func seatsFor(noOfPlayers:Int) -> [SideOfTable]
    {
        switch noOfPlayers
        {
        case 3 : return seatsFor3
        case 4 : return seatsFor4
        case 5 : return seatsFor5
        case 6 : return seatsFor6
        default : return []
        }
    }
    
}
