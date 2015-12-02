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
    var label : SKLabelNode? = nil
    var localLabel : SKSpriteNode? = nil
    var letterBackground : SKSpriteNode? = nil
    var originalScale = CGFloat(1.0)
    var originalCardPosition   = CGPointZero
    var originalCardRotation  = CGFloat(0.0)
    var originalCardZPosition  = CGFloat(0.0)
    
    
    /////////////////////////////////////////////////////
    /// Constructors
    /////////////////////////////////////////////////////
    init(card:PlayingCard,  texture: SKTexture = SKTexture(imageNamed: "Back1"))
    {
    self.card = card
    super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
      

    self.name = card.imageName
    self.userInteractionEnabled = false
    self.anchorPoint = CGPointMake(0.5, 0.5)
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
        if isUp {
            sprite.addLocalization()
        }
        scene.addChild(sprite)
        self.currentScene = scene
        return sprite
    }
    
    /////////////////////////////////////////////
    /// Instance Methods
    /////////////////////////////////////////////


    /// changing the anchorpoint is not something you can do with a SKAction
    /// therefore changing the anchorpoint without causing the sprite to jump requires finess
    
    func rotateAboutPoint(position:CGPoint, rotatePoint:CGPoint, zRotation:CGFloat) -> CGPoint
    {
        let dx1 = (rotatePoint.x - self.anchorPoint.x) * self.size.width
        let dy1 = (rotatePoint.y - self.anchorPoint.y) * self.size.height
        
        let dx = dx1 * cos(zRotation) - dy1 * sin(zRotation)
        let dy = dx1 * sin(zRotation) + dy1 * cos(zRotation)
        return CGPointMake(position.x+dx, position.y+dy)
    }
    func rotateAboutPoint(position:CGPoint, rotatePoint:CGPoint, zRotation:CGFloat, newScale:CGFloat) -> CGPoint
    {
        let dx1 = (self.anchorPoint.x - rotatePoint.x) * self.size.width  * newScale / self.yScale
        let dy1 = (self.anchorPoint.y - rotatePoint.y ) * self.size.height  * newScale / self.yScale
        
        
        let dx = dx1 * cos(zRotation) - dy1 * sin(zRotation)
        let dy = dx1 * sin(zRotation) + dy1 * cos(zRotation)
        return CGPointMake(position.x+dx, position.y+dy)
    }
    func updateAnchorPoint(anchorPoint:CGPoint = CGPointMake(0.5, 0.5))
    {
        
        self.position = rotateAboutPoint(self.position,rotatePoint: anchorPoint,zRotation:self.zRotation)
        
        self.anchorPoint = anchorPoint
    }
    /// changing the anchorpoint is not something you can do with a SKAction
    /// therefore changing the anchorpoint without causing the sprite to jump requires finess

    func removeLabel()
    {
        if let description = label
        {
            description.removeFromParent()
            label = nil
        }
    }
    func removeAll()
    {
        self.removeAllChildren()
        label = nil
        localLabel = nil
        letterBackground  = nil
    }
    func addLabel()
    {
        if label != nil { return }
        label = SKLabelNode(text:self.card.description)
        // let originalScale = self.yScale
        
        label!.position = CGPoint(x: 0.0, y:  self.size.height*(GameSettings.isBiggerDevice ? 0.18 : 0.37))
        label!.fontColor = UIColor.blackColor()
        label!.fontName = "Verdana"
        label!.fontSize = 11
      
        label!.zPosition =  0.5
        self.addChild(label!)
    
    }
    func tintRed()
    {
        self.color = UIColor.redColor()
        if let letter = self.letterBackground
        {
            letter.color = UIColor.redColor()
            letter.colorBlendFactor = 0.2
        }
        self.colorBlendFactor = 0.2
    }
    func removeTint()
    {
        self.color = UIColor.whiteColor()
        if let letter = self.letterBackground
        {
            letter.color = UIColor.whiteColor()
            letter.colorBlendFactor = 0.0
        }
        self.colorBlendFactor = 0.0
    }
    func addNumber()
    {
        if letterBackground != nil { return }
        
        switch card.value
        {
        case .CourtCard :
            if let deck = GameSettings.sharedInstance.deck
            {
            let local = deck.rankFor(card)
            if local == 0 { return }
            let color = card.suite.color
            localLabel = SKSpriteNode(imageNamed:"Number" + local.description)
            
            localLabel!.color = color
            localLabel!.colorBlendFactor = 1.0
            
            localLabel!.position = CGPointZero
            
            localLabel!.zPosition =  0.1
            letterBackground = SKSpriteNode(imageNamed:"letter")
            letterBackground!.zPosition =  0.1
            letterBackground!.anchorPoint=CGPoint(x: 0.5,y: 0.5)
            
            letterBackground!.position = CGPoint(x: -self.size.width*0.5+letterBackground!.size.width*0.5, y:  self.size.height*0.5-letterBackground!.size.height*0.5)
            letterBackground!.addChild(localLabel!)
            addChild(letterBackground!)
            }
        default : return
        }

        
    }
    func addLocalLetter()
    {
        if letterBackground != nil { return }
        
        if GameSettings.sharedInstance.useNumbersForCourtCards
        {
            addNumber()
            return
        }
        
        let local = card.value.localLetter
        if local == "" { return }
        let color = card.suite.color
        localLabel = SKSpriteNode(imageNamed:local + "_letter")
 
        localLabel!.color = color
        localLabel!.colorBlendFactor = 1.0

        localLabel!.position = CGPointZero
        
        localLabel!.zPosition =  0.1
        letterBackground = SKSpriteNode(imageNamed:"letter")
        letterBackground!.zPosition =  0.1
        letterBackground!.anchorPoint=CGPoint(x: 0.5,y: 0.5)
        
        letterBackground!.position = CGPoint(x: -self.size.width*0.5+letterBackground!.size.width*0.5, y:  self.size.height*0.5-letterBackground!.size.height*0.5)
        letterBackground!.addChild(localLabel!)
        addChild(letterBackground!)
       
    }
    /// the user has just started dragging the sprite
    func liftUp(positionInScene:CGPoint)
    {

        state = CardState.Dragged
        originalScale = self.yScale
        originalCardPosition  = self.position
        originalCardRotation  = self.zRotation
        originalCardZPosition  = self.zPosition


        self.zPosition = 120
      //  removeAllActions()
        runAction(
            SKAction.sequence([
                SKAction.group([
            SKAction.scaleTo(CardSize.Huge.scale, duration: 0.3),
            SKAction.rotateToAngle(0.0, duration: 0.3),
            SKAction.moveTo(positionInScene, duration: 0.3)
            ]),
            SKAction.runBlock
                {
                       self.addLabel()
                }]))
      
    }
    /// the user has just stopped dragging the sprite
    func setdown()
    {
        removeLabel()
        state = CardState.AtRest

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
        self.zPosition = 120
        self.position = positionInScene
        self.zRotation = 0.0
        self.setScale(CardSize.Huge.scale)
        addLabel()
    }
    
    /// the user has just switched which sprite they are dragging
    func setdownQuick()
    {
        removeAllActions()
        removeLabel()
        state = CardState.AtRest
        self.zPosition = originalCardZPosition
        self.position = originalCardPosition
        self.zRotation = originalCardRotation
        self.setScale(originalScale)
        self.fan?.reaZOrderCardsAtRest()
   
    }
    
    func needsLocalization() -> Bool
    {
        return card.value.localLetter != ""
    }
    func addLocalization()
    {
        if !needsLocalization() { return }
    let rotate = self.zRotation
        let xScale = self.xScale
        let yScale = self.yScale
    self.setScale(1.0)
    self.zRotation = 0
    self.addLocalLetter()
    self.zRotation = rotate
    self.setScale(yScale)
    self.xScale = xScale
    }
    /// Turn the card face up
    func flipUp()
    {
        if !isUp
        {
            texture = SKTexture(imageNamed: name!)
            isUp = true
            
        addLocalization()

        }
    }
    /// Turn the card
    func flip(toUp:Bool)
    {
        if toUp
        {
            flipUp()
        }
        else
        {
            flipDown()
        }
    }
    
    /// Turn the card face down
    func flipDown()
    {
        if isUp
        {
            self.removeAll()
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

func cardSprite(card :PlayingCard,isUp: Bool) -> CardSprite?
{
    if let sprite = self.cardSpriteNamed(card.imageName)
    {
        return sprite
    }
    return CardSprite.create(card, isUp:isUp, scene: self)
}

}