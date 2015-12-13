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
            case .Huge : return CGFloat(1.2)
            case .Big : return CGFloat(0.9)
            case .Medium : return CGFloat(0.6)
            case .Small : return CGFloat(0.45)
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
            case .Big : return  CGFloat(1.0)
            case .Small : return CGFloat(0.5)
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
    case Bigger
    case Huge

    
    var scale : CGFloat
        {
            switch self
            {
            case .Huge :
                switch DeviceSettings.layout
                {
                case .Phone :
                    return 65
                case .Pad :
                    return 55
                case .Portrait :
                    return 30
                }
            case .Bigger :
                switch DeviceSettings.layout
                {
                case .Portrait :
                    return 30
                case .Phone :
                    return 45
                case .Pad :
                    return 40
                }
            case .Big :
                switch DeviceSettings.layout
                {
                case .Portrait :
                    return 30
                case .Phone :
                    return 45
                case .Pad :
                    return 45
                }
            case .Medium :
                switch DeviceSettings.layout
                {
                case .Portrait :
                    return 32
                case .Phone :
                    return 38
                case .Pad :
                    return 32
                }
            case .Small    :
                switch DeviceSettings.layout
                {
                case .Portrait :
                    return 25
                case .Phone :
                    return 30
                case .Pad :
                    return 25
                }
    
            case .Smaller :
                switch DeviceSettings.layout
                {
                case .Portrait :
                    return 24
                case .Phone :
                    return 28
                case .Pad :
                    return 24
                }
 
            case .Smallest :
                switch DeviceSettings.layout
                {
                case .Portrait :
                    return 18
                case .Phone :
                    return 20
                case .Pad :
                    return 18
                }

                }
            }
}

