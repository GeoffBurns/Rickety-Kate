//
//  Bus.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//


import ReactiveSwift
import enum Result.NoError

class Bus {
    
    let (gameSignal,gameSink) = Signal<GameEvent,Result.NoError>.pipe()
    
    
    static let sharedInstance = Bus()
    fileprivate init() { }
    
    func send(_ gameEvent:GameEvent)
    {
    gameSink.send( value: gameEvent)
    }
}
