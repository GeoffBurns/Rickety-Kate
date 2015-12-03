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
    func schedule(delay delay: NSTimeInterval, handler: () -> Void)  {
        self.runAction(SKAction.sequence([SKAction.waitForDuration(delay), SKAction.runBlock({
            handler()
        })]))
    }
    
    /**
     Creates and schedules a repeating action
     
     :param: repeatInterval The interval between each execution of `handler`. Note that individual calls may be delayed; subsequent calls to `handler` will be based on the time the `NSTimer` was created.
     :param: handler A closure to execute after `delay`.
     
     :returns: The newly-created `NSTimer` instance.
     */
    func schedule(repeatInterval interval: NSTimeInterval, handler:  () -> Void) {
        self.runAction(SKAction.repeatActionForever( SKAction.sequence([SKAction.waitForDuration(interval), SKAction.runBlock({
            handler()
        })])))
    }
    
    func addSafelyTo(newParent:SKNode)
    {
     if self.parent == nil
      {
      newParent.addChild(self)
      }
    }
    
    
    
}