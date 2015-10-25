//
//  CardPileType.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 24/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation

/// Cards are transferred from pile to pile. Which is which?
// What purpose does a pile serve?
enum CardPileType : CustomStringConvertible
{
    case Hand
    case Passing
    case Won
    case Trick
    case Background
    
    var description : String {
        switch self {
            
        case .Hand: return "Hand"
        case .Passing: return "Passing"
        case .Won: return "Won"
        case .Trick: return "Trick"
        case .Background: return "Background"
        }
    }
}