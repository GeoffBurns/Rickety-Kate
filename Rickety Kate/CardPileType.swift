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
    case hand
    case passing
    case won
    case trick
    case background
    case dealt
    case stack
    case discard
    
    var description : String {
        switch self {
            
        case .hand: return "Hand"
        case .passing: return "Passing"
        case .won: return "Won"
        case .trick: return "Trick"
        case .background: return "Background"
        case .dealt: return "Dealt"
        case .stack: return "Stack"
        case .discard: return "Discard"
        }
    }
}
