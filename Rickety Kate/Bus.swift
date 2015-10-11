//
//  Bus.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import ReactiveCocoa

class Bus {
    
    let (gameSignal,gameSink) = Signal<GameEvent,NoError>.pipe()
    
    static let sharedInstance = Bus()
    private init() { }
    
    func send(gameEvent:GameEvent)
    {
    sendNext(gameSink, gameEvent)
    }
}
