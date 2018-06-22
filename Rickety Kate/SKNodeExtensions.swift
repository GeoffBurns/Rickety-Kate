//
//  SKNodeExtentions.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 26/10/2015.
//  Copyright © 2015 Nereids Gold. All rights reserved.
//

import SpriteKit



extension SKNode {
    /**
     Creates and schedules a one-time delayed action
     
     :param: delay The delay before execution.
     :param: handler A closure to execute after `delay`.
     
     :returns: The newly-created `NSTimer` instance.
     */
   func schedule(delay: TimeInterval, handler: @escaping () -> Void)  {
        self.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.run({
            handler()
        })]))
    }
    
    /**
     Creates and schedules a repeating action
     
     :param: repeatInterval The interval between each execution of `handler`. Note that individual calls may be delayed; subsequent calls to `handler` will be based on the time the `NSTimer` was created.
     :param: handler A closure to execute after `delay`.
     
     :returns: The newly-created `NSTimer` instance.
     */
    func schedule(repeatInterval interval: TimeInterval, handler:  @escaping () -> Void) {
        self.run(SKAction.repeatForever( SKAction.sequence([SKAction.wait(forDuration: interval), SKAction.run({
            handler()
        })])))
    }
 
    func addSafelyTo(_ newParent:SKNode)
    {
     if self.parent == nil
      {
      newParent.addChild(self)
      }
    }
    
    
    
}
