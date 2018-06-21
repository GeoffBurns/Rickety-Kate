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
    case small   // e.g. other players hand
    case medium  // e.g. in the trick pile
    case big     // e.g. in your hand
    case huge    // e.g. being dragged

    
    var scale : CGFloat
        {
            switch self
            {
            case .huge : return DeviceSettings.isPhone ?
            (DeviceSettings.isBigPhone ? CGFloat(0.9) : CGFloat(0.6))
            : CGFloat(1.2)
         
            case .big :    return DeviceSettings.isPhone ?
                (DeviceSettings.isBigPhone ? CGFloat(0.6) : CGFloat(0.45))
                : CGFloat(0.9)
            case .medium : return DeviceSettings.isPhone ? CGFloat(0.3) : CGFloat(0.6)
            case .small : return DeviceSettings.isPhone ? CGFloat(0.22) : CGFloat(0.45)
            }
    }
    var zOrder : CGFloat
        {
            switch self
            {
            case .huge : return 200.0
            case .big : return 150.0
            case .medium : return 80.0
            case .small : return 30.0
            }
    }
}

enum ButtonSize
{
    case small   // e.g. other players hand
    case big     // e.g. in your hand
    
    
    var scale : CGFloat
        {
            switch self
            {
            case .big : return   DeviceSettings.isPhone ? CGFloat(0.5) : CGFloat(1.0)
            case .small : return  DeviceSettings.isPhone ? CGFloat(0.25) :CGFloat(0.5)
            }
    }
}

enum FontSize
{
    case smallest
    case smaller
    case small
    case medium
    case big
    case bigger
    case huge

    
    var scale : CGFloat
        {
            switch self
            {
            case .huge :
                switch DeviceSettings.layout
                {
                case .phone :
                    return 28
                case .pad :
                    return 55
                case .portrait :
                    return 30
                }
            case .bigger :
                switch DeviceSettings.layout
                {
                case .portrait :
                    return 30
                case .phone :
                    return 22
                case .pad :
                    return 40
                }
            case .big :
                switch DeviceSettings.layout
                {
                case .portrait :
                    return 30
                case .phone :
                    return 22
                case .pad :
                    return 45
                }
            case .medium :
                switch DeviceSettings.layout
                {
                case .portrait :
                    return 32
                case .phone :
                    return 19
                case .pad :
                    return 32
                }
            case .small    :
                switch DeviceSettings.layout
                {
                case .portrait :
                    return 25
                case .phone :
                    return 15
                case .pad :
                    return 25
                }
    
            case .smaller :
                switch DeviceSettings.layout
                {
                case .portrait :
                    return 24
                case .phone :
                    return 14
                case .pad :
                    return 24
                }
 
            case .smallest :
                switch DeviceSettings.layout
                {
                case .portrait :
                    return 18
                case .phone :
                    return 10
                case .pad :
                    return 18
                }

                }
            }
}

