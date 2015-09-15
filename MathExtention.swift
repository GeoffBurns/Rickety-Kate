//
//  MathExtention.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 14/09/2015.
//  Copyright (c) 2015 Nereids Gold. All rights reserved.
//

import Foundation
import SpriteKit

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}


extension Double {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}
