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
    
    let (noteSignal,noteSink) = Signal<GameNotice,Result.NoError>.pipe()
    
    static let sharedInstance = Bus()
    fileprivate init() { }
    
    static func send(_ gameEvent:GameEvent)
    {
        sharedInstance.gameSink.send( value: gameEvent)
    }
    static func send(_ gameNotice:GameNotice)
    {
        sharedInstance.noteSink.send( value: gameNotice)
    }
    
    func send(_ gameEvent:GameEvent)
    {
    gameSink.send( value: gameEvent)
    }
    func send(_ gameNotice:GameNotice)
    {
        noteSink.send( value: gameNotice)
    }
}
