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
public class CardPile
{
 
    static let defaultSpread = CGFloat(10)
    var cards = [PlayingCard]() { didSet { update() } }
    var isUp = false
    var sizeOfCards = CardSize.Small
    weak var scene : SKNode? = nil
    weak var discardAreas : HasDiscardArea? = nil
    var fullHand = defaultSpread
    weak var player : CardHolderBase? = nil
    var sideOfTable = SideOfTable.Bottom
    var direction = Direction.Up
    var isFanClosed = false
    var isFanOpen :Bool { return !isFanClosed }
    var isBackground : Bool = false
        { didSet {  createSprite = isBackground ? { $1.whiteCardSprite($0) } : { $1.cardSprite($0,isUp: self.isUp) }} }
    var name = ""
    var createSprite : CreateSprite = { $1.cardSprite($0) }
    var position = CGPointZero
    var zPositon = CGFloat(0)
    static let straightAnchorPoint = CGPoint(x: 0.5,y: 0.5)
    var speed = GameSettings.sharedInstance.tossDuration
    var cardAnchorPoint : CGPoint { get { return CardPile.straightAnchorPoint }}
    var sprites : [SKNode] { return cards.map { createSprite($0,scene!)! } }
    subscript(index: Int) -> PlayingCard { return cards[index] }
    
    init(name:String,player:CardHolderBase? = nil) { self.name = name; self.player = player  }
 
    func setup(scene:HasDiscardArea, direction: Direction, position: CGPoint, isUp: Bool = false, sizeOfCards: CardSize = CardSize.Small)
    {
        self.discardAreas = scene
        self.scene = scene as? SKNode
        self.direction = direction
        self.position = position
        self.isUp = isUp
        self.sizeOfCards = sizeOfCards
        self.isFanClosed = true
        self.zPositon = self.sizeOfCards.zOrder
    }
    
    func transferFrom(pile:CardPile)
    {
        appendContentsOf(pile.cards)
        pile.clear()
    }
    func replaceFrom(pile:CardPile)
    {
        replaceWithContentsOf(pile.cards)
        pile.clear()
    }
    
    func transferCardFrom(pile:CardPile, card:PlayingCard) -> PlayingCard?
    {
        append(card)
        return pile.remove(card)
    }
    
    func discardAll()
    {
       if isBackground
       {
        discardAreas?.discardWhitePile.replaceFrom(self)
        }
        else
       {
        discardAreas?.discardPile.replaceFrom(self)
        }
    }
    func append(card:PlayingCard)
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
    func appendContentsOf(newCards:[PlayingCard])
    {
        let count = cards.count
        cards.appendContentsOf(newCards)
        
        for (i,card) in cards.enumerate()
        {
            rearrangeFor(card, positionInSpread: CGFloat(i+count),  fullHand: 1)
        }
    }
    func replaceWithContentsOf(newCards:[PlayingCard])
    {
        cards = newCards
        
        
        for (i,card) in cards.enumerate()
        {
            rearrangeFor(card, positionInSpread: CGFloat(i),  fullHand: 1)
        }
    }
    func remove(card:PlayingCard) -> PlayingCard?
    {
        if let index = cards.indexOf(card)
        {
            return cards.removeAtIndex(index)
        }
        return nil
    }
    func positionOfCard(cpositionInSpread:CGFloat, spriteHeight:CGFloat,fullHand:CGFloat) -> CGPoint
    {
        return position
    }
    func rotationOfCard(positionInSpread:CGFloat, fullHand:CGFloat) -> CGFloat
    {
        return direction.rotationOfCard(positionInSpread, fullHand:fullHand) - 30.degreesToRadians
    }
    


    func rearrangeFor(card:PlayingCard,positionInSpread:CGFloat,
        fullHand:CGFloat)
    {
        if let cardScene = scene,
               sprite = createSprite(card,cardScene)
        {
            sprite.removeLabel()
            if sprite.fan !== self { sprite.fan = self }
            
            if (sprite.state != CardState.AtRest)
            {
                sprite.zPosition = 140
                sprite.state = CardState.AtRest
            }
            
            // Stop all running animations before starting new ones
            sprite.removeAllActions()
            sprite.positionInSpread = positionInSpread
            
            // PlayerOne's cards are larger
            let newScale =  sizeOfCards.scale
            
            let newHeight = newScale * sprite.size.height / sprite.yScale

            sprite.removeTint()

            
            var flipAction = (SKAction.scaleTo(sizeOfCards.scale, duration: speed))
         
            let rotationAngle = rotationOfCard(positionInSpread, fullHand:fullHand)
            let rotateAction = (SKAction.rotateToAngle(rotationAngle, duration:(speed*0.8)))
            let newPosition =  sprite.rotateAboutPoint(
                positionOfCard(positionInSpread, spriteHeight: newHeight, fullHand:fullHand),
                rotatePoint:cardAnchorPoint,
                zRotation:rotationAngle,
                newScale:sizeOfCards.scale)
            
            let moveAction = (SKAction.moveTo(newPosition, duration:(speed*0.8)))
            let scaleAction =  (SKAction.scaleTo(sizeOfCards.scale, duration: speed))
            let scaleYAction =  SKAction.scaleYTo(sizeOfCards.scale, duration: speed)
            var groupAction = SKAction.group([moveAction,rotateAction,scaleAction])
            
            if isUp && !sprite.isUp
            {
                //    sprite.flipUp()
                flipAction = (SKAction.sequence([
                    SKAction.scaleXTo(0.0, duration: speed*0.5),
                    SKAction.runBlock({ [unowned sprite] in
                        sprite.flipUp()
                    }) ,
                    SKAction.scaleXTo(sizeOfCards.scale, duration: speed*0.4)
                
                    ]))
                groupAction = SKAction.group([moveAction,rotateAction,flipAction,scaleYAction])
            }
            else if !isUp && sprite.isUp
            {
                // sprite.flipDown()
                flipAction = (SKAction.sequence([
                    SKAction.scaleXTo(0.0, duration: speed*0.5),
                    SKAction.runBlock({ [unowned sprite] in
              
                        sprite.flipDown()
                    }) ,
                    SKAction.scaleXTo(sizeOfCards.scale, duration: speed*0.4)
                    ]))
                groupAction = SKAction.group([moveAction,rotateAction,flipAction,scaleYAction])
            }
            
            sprite.runAction(SKAction.sequence([groupAction, SKAction.runBlock({ [unowned sprite, unowned self] in
                sprite.zPosition = self.zPositon + positionInSpread
    
    
            }) ]))
          
         
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
        for (positionInSpread,card) in cards.enumerate()
        {
            if let cardScene = scene,
                sprite = createSprite(card,cardScene)
                where sprite.state == CardState.AtRest
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
                sprite = createSprite(card,cardScene)
            where sprite.state == CardState.AtRest
            {
            sprite.zPosition = self.zPositon  + positionInSpread
            }
            positionInSpread++
            
        }
    }

    
    
}


