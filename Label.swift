//
//  Label.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 25/10/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//
import SpriteKit


typealias TextChangeHandler = (String?) -> Void
typealias FontSizeChangeHandler = (CGFloat) -> Void

class Label : SKLabelNode
{
    override var text : String? { didSet { for textChangeHandler in textChangeHandlers { textChangeHandler(text)}}}
    override var fontSize : CGFloat { didSet { for fontSizeChangeHandler in fontSizeChangeHandlers { fontSizeChangeHandler(fontSize)}}}

    var textChangeHandlers = [TextChangeHandler]()
    var fontSizeChangeHandlers = [FontSizeChangeHandler]()

    var innerNode : SKLabelNode? = nil
   
    func withShadow() -> Label
    {
        if innerNode != nil
        {
            return self
        }
        innerNode = SKLabelNode(fontNamed: self.fontName)

        self.fontColor = UIColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 0.7)
        innerNode!.position = CGPoint(x:-2,y:2)
        innerNode!.fontColor = UIColor.whiteColor()
        innerNode!.zPosition = 10
        addChild(innerNode!)
        
        textChangeHandlers.append({self.innerNode!.text = $0})
        fontSizeChangeHandlers.append({self.innerNode!.fontSize = $0})
        
        return self   
    }
    
    func withFadeInOut() -> Label
    {
        textChangeHandlers.append(startfadeInOut)
        
        return self
    }
    
    func startfadeInOut(text: String?)
    {
        removeAllActions()
        
        alpha = 1.0
        if let t = text  where t != ""
        {
            let action = SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.fadeOutWithDuration(6),
                    SKAction.waitForDuration(10),
                    SKAction.fadeInWithDuration(4),
                    SKAction.waitForDuration(5),
                    ] )
            )
            runAction(action)
        }
    }
    
    func resetToScene(scene:SKNode)
    {
        if parent != nil
        {
            removeFromParent()
        }
        text = ""
        scene.addChild(self)
    }
}
