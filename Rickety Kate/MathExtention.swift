//
//  MathExtention.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 14/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat.pi / 180.0
    }
}


extension Double {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat.pi / 180.0
    }
}
