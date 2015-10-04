//
//  CardSize.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 24/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

// the cards size depends on where they are
enum CardSize
{
    case Small   // e.g. other players hand
    case Medium  // e.g. in the trick pile
    case Big     // e.g. in your hand
    case Huge    // e.g. being dragged
    var scale : CGFloat
        {
            switch self
            {
            case .Huge : return GameSettings.isPhone6Plus ?  CGFloat(2.4) : CGFloat(1.2)
            case .Big : return GameSettings.isPhone6Plus ?  CGFloat(1.8) : CGFloat(0.9)
            case .Medium : return GameSettings.isPhone6Plus ?  CGFloat(1.2) : CGFloat(0.6)
            case .Small : return GameSettings.isPhone6Plus ?  CGFloat(0.9) : CGFloat(0.45)
            }
    }
    
    var zOrder : CGFloat
        {
            switch self
            {
            case .Huge : return 150.0
            case .Big : return 100.0
            case .Medium : return 50.0
            case .Small : return 10.0
            }
    }
}

enum ButtonSize
{
    case Small   // e.g. other players hand
    case Big     // e.g. in your hand
    
    var scale : CGFloat
        {
            switch self
            {
            case .Big : return GameSettings.isPhone6Plus ?  CGFloat(1.5) : CGFloat(1.0)
            case .Small : return GameSettings.isPhone6Plus ?  CGFloat(0.75) : CGFloat(0.5) 
            }
    }
}

