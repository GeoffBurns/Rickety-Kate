//
//  CardSprite.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//


import SpriteKit


/// controls the appearance of the card on the screen
class CardSprite : SKSpriteNode
{
    /////////////////////////////////////////////////////
    /// Variables
    /////////////////////////////////////////////////////
    weak static var currentScene : SKNode? = nil
    weak var fan : CardPile? = nil
    weak var player : CardPlayer? = nil
    var card : PlayingCard
    var isUp = false
    var positionInSpread = CGFloat(0.0)
    var state = CardState.AtRest
    var originalTouch : CGPoint = CGPointZero
    
    var originalScale = CGFloat(1.0)
    var originalCardPosition   = CGPointZero
    var originalCardRotation  = CGFloat(0.0)
    var originalCardZPosition  = CGFloat(0.0)
    var originalCardAnchor  = CGPointZero
    
    /////////////////////////////////////////////////////
    /// Constructors
    /////////////////////////////////////////////////////
    private init(card:PlayingCard, player : CardPlayer?)
    {
    self.card = card
    self.player = player
        
    let back =  SKTexture(imageNamed: "Back1")
    super.init(texture: back, color: UIColor.whiteColor(), size: back.size())
      

    self.name = card.imageName
    self.userInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func add(card:PlayingCard, player : CardPlayer?, scene:SKNode)
    {
        CardSprite.create(card, player: player,scene: scene)
      
    }
    static func create(card:PlayingCard, player : CardPlayer?, scene:SKNode) -> CardSprite
    {
        let sprite = CardSprite(card: card, player: player)
        scene.addChild(sprite)
        self.currentScene = scene
        return sprite
    }
    

    /////////////////////////////////////////////
    /// Instance Methods
    /////////////////////////////////////////////
    
    /// changing the anchorpoint is not something you can do with a SKAction
    /// therefore changing the anchorpoint without causing the sprite to jump requires finess
    func updateAnchorPoint(anchorPoint:CGPoint)
    {
    let dx1 = (anchorPoint.x - self.anchorPoint.x) * self.size.width
    let dy1 = (anchorPoint.y - self.anchorPoint.y) * self.size.height
    
    let dx = dx1 * cos(self.zRotation) - dy1 * sin(self.zRotation)
    let dy = dx1 * sin(self.zRotation) + dy1 * cos(self.zRotation)
    self.position = CGPointMake(self.position.x+dx, self.position.y+dy)
    self.anchorPoint = anchorPoint
    }
    
    /// the user has just started dragging the sprite
    func liftUp(positionInScene:CGPoint)
    {
        state = CardState.Dragged
        originalScale = self.yScale
        originalCardPosition  = self.position
        originalCardRotation  = self.zRotation
        originalCardZPosition  = self.zPosition
        originalCardAnchor  = self.anchorPoint
        updateAnchorPoint( CGPoint(x: 0.5, y: 0.5))
        self.zPosition = 120
      //  removeAllActions()
        runAction(SKAction.group([
            SKAction.scaleTo(1.2, duration: 0.3),
            SKAction.rotateToAngle(0.0, duration: 0.3),
            SKAction.moveTo(positionInScene, duration: 0.3)
            ]))
      
    }
    /// the user has just stopped dragging the sprite
    func setdown()
    {
        state = CardState.AtRest
        updateAnchorPoint(originalCardAnchor)
    //    removeAllActions()
        runAction(SKAction.sequence([SKAction.group([
            SKAction.scaleTo(originalScale, duration: 0.3),
            SKAction.rotateToAngle(originalCardRotation, duration: 0.3),
            SKAction.moveTo(originalCardPosition, duration: 0.3)
            ]),
            SKAction.runBlock {
               self.zPosition = self.originalCardZPosition
                self.fan?.reaZOrderCardsAtRest()
            }]))
    }
    /// the user has just switched which sprite they are dragging
    func liftUpQuick(positionInScene:CGPoint)
    {
        removeAllActions()
        state = CardState.Dragged
        originalScale = self.yScale
        originalCardPosition  = self.position
        originalCardRotation  = self.zRotation
        originalCardAnchor  = self.anchorPoint
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 120
        self.position = positionInScene
        self.zRotation = 0.0
        self.setScale(1.2)
       
    }
    
    /// the user has just switched which sprite they are dragging
    func setdownQuick()
    {
        removeAllActions()
        state = CardState.AtRest
        self.anchorPoint = originalCardAnchor
        self.zPosition = originalCardZPosition
        self.position = originalCardPosition
        self.zRotation = originalCardRotation
        self.setScale(originalScale)
         self.fan?.reaZOrderCardsAtRest()
   
    }
    /// Turn the card face up
    func flipUp()
    {
        if !isUp
        {
            texture = SKTexture(imageNamed: name!)
            isUp = true
        }
    }
    
    /// Turn the card face down
    func flipDown()
    {
        if isUp
        {
            texture = SKTexture(imageNamed: "Back1")
            isUp = false

        }
    }
}


extension SKNode
{
 func cardSpriteNamed(cardname :String) -> CardSprite?
    {
    return (self.childNodeWithName(cardname) as? CardSprite?)!
    }
func cardSprite(card :PlayingCard) -> CardSprite?
    {
    return self.cardSpriteNamed(card.imageName)
    }
}