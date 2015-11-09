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
            case .Huge : return GameSettings.isBig ?  CGFloat(2.4) : CGFloat(1.2)
            case .Big : return GameSettings.isBig ?  CGFloat(1.8) : CGFloat(0.9)
            case .Medium : return GameSettings.isBig ?  CGFloat(1.2) : CGFloat(0.6)
            case .Small : return GameSettings.isBig ?  CGFloat(0.9) : CGFloat(0.45)
            }
    }
    
    var zOrder : CGFloat
        {
            switch self
            {
            case .Huge : return 200.0
            case .Big : return 150.0
            case .Medium : return 80.0
            case .Small : return 30.0
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
            case .Big : return GameSettings.isBig ?  CGFloat(1.5) : CGFloat(1.0)
            case .Small : return GameSettings.isBig ?  CGFloat(0.75) : CGFloat(0.5)
            }
    }
}

enum FontSize
{
    case Smallest
    case Smaller
    case Small
    case Medium
    case Big
    case Huge
    var scale : CGFloat
        {
            switch self
            {
            case .Huge :
                switch GameSettings.device
                 {
                  case .Phone :
                     return 65
                  case .Phone6plus :
                     return 90
                  case .Pad :
                     return 55
                  case .PadPro :
                     return 100
                }
            case .Big : return 45
            case .Medium :
                switch GameSettings.device
            {
            case .Phone :
                return 38
            case .Phone6plus :
                return 55
            case .Pad :
                return 32
            case .PadPro :
                return 60
            }

            
        
            case .Small    :
                switch GameSettings.device
                  {
                  case .Phone :
                     return 30
                  case .Phone6plus :
                     return 40
                  case .Pad :
                     return 25
                  case .PadPro :
                     return 50
                  }
            case .Smaller :
                switch GameSettings.device
                {
                case .Phone :
                    return 28
                case .Phone6plus :
                    return 42
                case .Pad :
                    return 24
                case .PadPro :
                    return 48
                }
            case .Smallest :
                switch GameSettings.device
                {
                    case .Phone :
                        return 20
                    case .Phone6plus :
                        return 30
                    case .Pad :
                        return 18
                    case .PadPro :
                        return 36
                }
            }
}

}
