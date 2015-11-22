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
    var fan : CardPile? = nil
        {
        didSet {
            if let f = fan
            where f.player != nil {
                player = f.player
            }

        }
    }
    var player : CardHolderBase? = nil
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
    init(card:PlayingCard,  texture: SKTexture = SKTexture(imageNamed: "Back1"))
    {
    self.card = card
    super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
      

    self.name = card.imageName
    self.userInteractionEnabled = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    static func create(card:PlayingCard, scene:SKNode) -> CardSprite
    {
        let sprite = CardSprite(card: card)
        scene.addChild(sprite)
        self.currentScene = scene
        return sprite
    }
    
    static func create(card:PlayingCard, isUp: Bool, scene:SKNode) -> CardSprite
    {
        let sprite = CardSprite(card: card,
            texture: isUp
                ? SKTexture(imageNamed: card.imageName)
                :SKTexture(imageNamed: "Back1"))
        sprite.isUp = isUp
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
        
        addLabel()

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
            SKAction.scaleTo(CardSize.Huge.scale, duration: 0.3),
            SKAction.rotateToAngle(0.0, duration: 0.3),
            SKAction.moveTo(positionInScene, duration: 0.3)
            ]))
      
    }
    /// the user has just stopped dragging the sprite
    func setdown()
    {
        
        removeLabel()
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
    func removeLabel()
    {
        self.removeAllChildren()
    }
    func addLabel()
    {
        let label = SKLabelNode(text:self.card.description)
        
        
        label.position = CGPoint(x: 0.0, y:  self.size.height*(GameSettings.isBiggerDevice ? 0.25 : 0.49)) /// CGPoint(x: 0.5*node.size.width, y: node.size.height*0.98)
        label.fontColor = UIColor.blackColor()
        label.fontName = "Verdana"
        label.fontSize = 11
        label.zPosition = CardSize.Huge.zOrder + 100.0
        self.addChild(label)
    }
    /// the user has just switched which sprite they are dragging
    func liftUpQuick(positionInScene:CGPoint)
    {
        removeAllActions()
        addLabel()
        
        state = CardState.Dragged
        originalScale = self.yScale
        originalCardPosition  = self.position
        originalCardRotation  = self.zRotation
        originalCardAnchor  = self.anchorPoint
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 120
        self.position = positionInScene
        self.zRotation = 0.0
        self.setScale(CardSize.Huge.scale)
       
    }
    
    /// the user has just switched which sprite they are dragging
    func setdownQuick()
    {
        removeAllActions()
        removeLabel()
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

/// controls the appearance of the card on the screen
class WhiteCardSprite : CardSprite
{
    
    override var  anchorPoint : CGPoint { didSet { if let w = white, b = blank, o = outline, s = shadow, os = outlineShadow {
        w.anchorPoint = self.anchorPoint
        b.anchorPoint = self.anchorPoint
        o.anchorPoint = self.anchorPoint
        s.anchorPoint = self.anchorPoint
        os.anchorPoint = self.anchorPoint
        } } }
    override var  zPosition : CGFloat { didSet { if let w = white, b = blank, o = outline, s = shadow, os = outlineShadow {
        w.zPosition = self.zPosition + 0.5
        b.zPosition = self.zPosition
        o.zPosition = self.zPosition  + 0.7
        s.zPosition = self.zPosition  + 0.4
        os.zPosition = self.zPosition  + 0.6
        } } }
    
    var white : SKSpriteNode? = nil
    var shadow : SKSpriteNode? = nil
    var blank : SKSpriteNode? = nil
    var outline : SKSpriteNode? = nil
    var outlineShadow : SKSpriteNode? = nil
    private init(card:PlayingCard)
    {
        super.init(card:card, texture: SKTexture(imageNamed: "blank"))
        
        white = SKSpriteNode(imageNamed: card.whiteImageName)
        
        blank = SKSpriteNode(imageNamed:  "blank")
        outline = SKSpriteNode(imageNamed:  "outline")
        shadow = SKSpriteNode(imageNamed:  card.whiteImageName)
        outlineShadow = SKSpriteNode(imageNamed:  "outline")
        
        shadow!.color =  UIColor.blackColor()
        outlineShadow!.color =  UIColor.blackColor()
        blank!.color =  GameSettings.backgroundColor
        
        shadow!.colorBlendFactor = 1.0
        outlineShadow!.colorBlendFactor = 1.0
        blank!.colorBlendFactor = 1.0
        
        shadow!.position = CGPoint(x:2,y:-2)
        outlineShadow!.position = CGPoint(x:2,y:-2)
        
      //  self.color =  UIColor.blackColor() //  GameSettings.backgroundColor
      //  self.colorBlendFactor = 1.0
       // white!.color = UIColor.blackColor()
        // white!.colorBlendFactor = 1.0
        
        blank!.zPosition = 0
        white!.zPosition = 0.5
        outline!.zPosition = 0.7
        shadow!.zPosition = 0.4
        outlineShadow!.zPosition = 0.6
        
        
        self.addChild(blank!)
        self.addChild(white!)
        self.addChild(outline!)
        self.addChild(shadow!)
        self.addChild(outlineShadow!)
        self.name = card.whiteImageName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    static func createWhite(card:PlayingCard, scene:SKNode) -> CardSprite
    {
        let sprite = WhiteCardSprite(card: card)
        scene.addChild(sprite)
        self.currentScene = scene
        return sprite
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
        if let sprite = self.cardSpriteNamed(card.imageName)
        {
            return sprite
        }
        return CardSprite.create(card, scene: self)
    }
    
func whiteCardSprite(card :PlayingCard) -> CardSprite?
    {
        if let sprite = self.cardSpriteNamed(card.whiteImageName)
        {
            return sprite
        }
        return WhiteCardSprite.createWhite(card, scene: self)
    }
}