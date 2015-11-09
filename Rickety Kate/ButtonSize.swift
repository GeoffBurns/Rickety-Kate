//
//  ButtonSize.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 4/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

enum ButtonSize
{
    case Small   // e.g. other players hand
    case Big     // e.g. in your hand
    
    var scale : CGFloat
        {
            switch self
            {
            case .Big : return GameSettings.isBig ?  CGFloat(1.5) : CGFloat(1.0)
            case .Small : return GameSettings.isBig ?  CGFloat(0.75) : CGFloat(0.5)
            }
    }
}
