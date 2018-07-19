//
//  CardPile.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 23/09/2015.
//  Copyright © 2015 Geoff Burns All rights reserved.
//

import SpriteKit

typealias CreateSprite = (PlayingCard,SKNode) -> CardSprite?

/// How the cards are displayed in a pile
open class CardPile : PositionedOnTable
{
 
    static let defaultSpread = CGFloat(10)
    var cards = [PlayingCard]() { didSet { update() } }
    var tableSize : CGSize
    var isUp = false { didSet { update() } }
    var sizeOfCards = CardSize.small
    weak var scene : SKNode? = nil
    weak var discardAreas : HasDiscardArea? = nil
    var fullHand = defaultSpread
    weak var player : CardHolderBase? = nil
    var sideOfTable = SideOfTable.bottom
    var direction = Direction.up
    var isFanClosed = false
    var isFanOpen :Bool { return !isFanClosed }
    var isBackground : Bool = false
        { didSet {  createSprite = isBackground ? { $1.whiteCardSprite($0) } : { $1.cardSprite($0,isUp: self.isUp) }} }
    var name = ""
    var createSprite : CreateSprite = { $1.cardSprite($0) }
    var position = CGPoint.zero
    var zPositon = CGFloat(0)
    static let straightAnchorPoint = CGPoint(x: 0.5,y: 0.5)
    var speed = Game.settings.tossDuration
    var bannerHeight = CGFloat(0)
    var cardAnchorPoint : CGPoint { get { return CardPile.straightAnchorPoint }}
    var sprites : [SKNode] { return cards.map { createSprite($0,scene!)! } }
    subscript(index: Int) -> PlayingCard { return cards[index] }
    
    init(name:String,player:CardHolderBase? = nil) { self.name = name; self.player = player;  tableSize = CGSize() }
 
    func setup(_ scene:HasDiscardArea, direction: Direction, position: CGPoint, isUp: Bool = false, sizeOfCards: CardSize = CardSize.small)
    {
        self.discardAreas = scene
        self.scene = scene as? SKNode
        self.direction = direction
        self.position = position
        self.isUp = isUp
        self.sizeOfCards = sizeOfCards
        self.isFanClosed = true
        self.zPositon = isBackground ? 3 : self.sizeOfCards.zOrder
        tableSize = self.scene!.frame.size
    }
    
    func transferFrom(_ pile:CardPile)
    {
    
        appendContentsOf(pile.cards)
        pile.clear()
        
    }
    func replaceFrom(_ pile:CardPile)
    {
      
        replaceWithContentsOf(pile.cards)
          pile.clear()
       
    }
    
    func transferCardFrom(_ pile:CardPile, card:PlayingCard) -> PlayingCard?
    {
        let result = pile.remove(card)
        append(card)
        return result
    }
    
    func discardAll()
    {
       if isBackground
       {
        discardAreas?.discardWhitePile.transferFrom(self)
        }
        else
       {
        discardAreas?.discardPile.transferFrom(self)
        }
    }
    func append(_ card:PlayingCard)
    {
        let count = cards.count
        cards.append(card)
 
        rearrangeFor(card, positionInSpread: CGFloat(count),  fullHand: 1)
    }
    func update()
    {
        /// if its a pile instead of a fan you don't need to rearrange the pile for every change
    }
    func clear()
    {
        cards = []
    }
    func appendContentsOf(_ newCards:[PlayingCard])
    {
        let count = cards.count
        cards.append(contentsOf: newCards)
        
        for (i,card) in cards.enumerated()
        {
            rearrangeFor(card, positionInSpread: CGFloat(i+count),  fullHand: 1)
        }
    }
    
    func rearrange()
    {
        for (i,card) in cards.enumerated()
        {
            rearrangeFor(card, positionInSpread: CGFloat(i),  fullHand: 1)
        }
    }
    func rearrangeFast()
    {
        for (i,card) in cards.enumerated()
        {
            rearrangeFastFor(card, positionInSpread: CGFloat(i),  fullHand: 1)
        }
    }
    func replaceWithContentsOf(_ newCards:[PlayingCard])
    {
        cards = newCards
        
        
        for (i,card) in cards.enumerated()
        {
            rearrangeFor(card, positionInSpread: CGFloat(i),  fullHand: 1)
        }
    }
    func remove(_ card:PlayingCard) -> PlayingCard?
    {
        if let index = cards.index(of: card)
        {
            return cards.remove(at: index)
        }
        return nil
    }
    func positionOfCard(_ cpositionInSpread:CGFloat, spriteHeight:CGFloat,fullHand:CGFloat) -> CGPoint
    {
        return position
    }
    func rotationOfCard(_ positionInSpread:CGFloat, fullHand:CGFloat) -> CGFloat
    {
        return direction.rotationOfCard(positionInSpread, fullHand:fullHand) - 30.degreesToRadians
    }
    


    func rearrangeFor(_ card:PlayingCard,positionInSpread:CGFloat,
        fullHand:CGFloat)
    {
        if let cardScene = scene,
               let sprite = createSprite(card,cardScene)
        {
            sprite.removeLabel()
            if sprite.fan !== self {
                
                if let fan = sprite.fan, fan.cards.contains(card)
                {
                    var otherPlayer = ""
                    var thisPlayer = ""
                    if let fp = fan.player
                    {
                        otherPlayer = fp.name
                    }
                    if let sp = self.player
                    {
                        thisPlayer = sp.name
                    }
                    
                    NSLog("%@ in two fans %@ %@ and %@ %@", card.description,self.name,thisPlayer,fan.name,otherPlayer)
                }
                sprite.fan = self
            }
            
            if (sprite.state != CardState.atRest)
            {
                sprite.zPosition = isBackground ? 3 : 140
                sprite.state = CardState.atRest
            }
     
            // Stop all running animations before starting new ones
            sprite.removeAllActions()
            sprite.positionInSpread = positionInSpread
            
            // PlayerOne's cards are larger
            let newScale =  sizeOfCards.scale
            
            let newHeight = newScale * sprite.size.height / sprite.yScale

            sprite.removeTint()

            
            var flipAction = (SKAction.scale(to: sizeOfCards.scale, duration: speed))
         
            let rotationAngle = rotationOfCard(positionInSpread, fullHand:fullHand)
            let rotateAction = (SKAction.rotate(toAngle: rotationAngle, duration:(speed*0.8)))
            let newPosition =  sprite.rotateAboutPoint(
                positionOfCard(positionInSpread, spriteHeight: newHeight, fullHand:fullHand),
                rotatePoint:cardAnchorPoint,
                zRotation:rotationAngle,
                newScale:sizeOfCards.scale)
            
            let moveAction = (SKAction.move(to: newPosition, duration:(speed*0.8)))
            let scaleAction =  (SKAction.scale(to: sizeOfCards.scale, duration: speed))
            let scaleYAction =  SKAction.scaleY(to: sizeOfCards.scale, duration: speed)
            var groupAction = SKAction.group([moveAction,rotateAction,scaleAction])
            
            if isUp && !sprite.isUp
            {
                //    sprite.flipUp()
                flipAction = (SKAction.sequence([
                    SKAction.scaleX(to: 0.0, duration: speed*0.5),
                    SKAction.run({ [weak sprite] in
                        if let s = sprite
                        {
                        s.flipUp()
                        }
                    }) ,
                    SKAction.scaleX(to: sizeOfCards.scale, duration: speed*0.4)
                
                    ]))
                groupAction = SKAction.group([moveAction,rotateAction,flipAction,scaleYAction])
            }
            else if !isUp && sprite.isUp
            {
              
                flipAction = (SKAction.sequence([
                    SKAction.scaleX(to: 0.0, duration: speed*0.5),
                    SKAction.run({ [weak sprite] in
                        if let s = sprite
                        {
                            s.flipDown()
                        }
                      
                    }) ,
                    SKAction.scaleX(to: sizeOfCards.scale, duration: speed*0.4)
                    ]))
                groupAction = SKAction.group([moveAction,rotateAction,flipAction,scaleYAction])
            }
            
            sprite.run(SKAction.sequence([groupAction, SKAction.run({ [weak sprite, weak self] in
                if let s = self,
                       let sp = sprite
                {
                sp.zPosition = s.zPositon + positionInSpread
                }
    
    
            }) ]))
          
         
        }
    }
    
    
    func rearrangeFastFor(_ card:PlayingCard,positionInSpread:CGFloat,
        fullHand:CGFloat)
    {
        if let cardScene = scene,
            let sprite = createSprite(card,cardScene)
        {
            sprite.removeLabel()
            if sprite.fan !== self { sprite.fan = self }
            
            if (sprite.state != CardState.atRest)
            {
                sprite.zPosition = isBackground ? 3 : 140
                sprite.state = CardState.atRest
            }
            else
            {
                sprite.zPosition = self.zPositon
            }
            
            // Stop all running animations before starting new ones
            sprite.removeAllActions()
            sprite.positionInSpread = positionInSpread
            
            // PlayerOne's cards are larger
            let newScale =  sizeOfCards.scale
            
            let newHeight = newScale * sprite.size.height / sprite.yScale
            
            sprite.removeTint()
            
            
            
            sprite.setScale(sizeOfCards.scale)
            
            let rotationAngle = rotationOfCard(positionInSpread, fullHand:fullHand)
            sprite.zRotation = rotationAngle
            sprite.position =  sprite.rotateAboutPoint(
                positionOfCard(positionInSpread, spriteHeight: newHeight, fullHand:fullHand),
                rotatePoint:cardAnchorPoint,                zRotation:rotationAngle,
                newScale:sizeOfCards.scale)
            
            
            if isUp && !sprite.isUp
            {
        
                        sprite.flipUp()
            
            }
            else if !isUp && sprite.isUp
            {

                        
                        sprite.flipDown()
                
            }
            
                sprite.zPosition = self.zPositon + positionInSpread
                
            
            
            
        }
    }
    
    func rearrangeCardsAtRest()
    {
        if(scene==nil)
        {
            return
        }
        var fullHand = CardPile.defaultSpread
        let noCards = CGFloat(cards.count)
        var positionStart = CGFloat(0)
        if isFanOpen
        {
            positionStart = (fullHand - noCards) * 0.5
            if fullHand < noCards
            {
                fullHand = noCards
                positionStart = CGFloat(0)
            }
        }
        for (positionInSpread,card) in cards.enumerated()
        {
            if let cardScene = scene,
                let sprite = createSprite(card,cardScene), sprite.state == CardState.atRest
            {
                rearrangeFor(card,positionInSpread:CGFloat(positionInSpread)+positionStart, fullHand:fullHand)
            }
        }
    }

    func reaZOrderCardsAtRest()
    {
        if(scene==nil)
        {
            return
        }
        var fullHand = CardPile.defaultSpread
        let noCards = CGFloat(cards.count)
        var positionInSpread = CGFloat(0)
        
        if isFanOpen
        {
            positionInSpread = (fullHand - noCards) * 0.5
            if fullHand < noCards
            {
                fullHand = noCards
                positionInSpread = CGFloat(0)
            }
        }
        for card in cards
        {
            if let cardScene = scene,
                let sprite = createSprite(card,cardScene), sprite.state == CardState.atRest
            {
            sprite.zPosition = self.zPositon  + positionInSpread
            }
            positionInSpread += 1
            
        }
    }

    
    
}


