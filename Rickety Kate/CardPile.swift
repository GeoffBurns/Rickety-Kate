//
//  CardPile.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 23/09/2015.
//  Copyright © 2015 Geoff Burns All rights reserved.
//

import SpriteKit


/// How the cards are displayed in a pile
class CardPile
{
    var cards : [PlayingCard] = [] { didSet { update() } }
    var isUp = false
    var sizeOfCards = CardSize.Small
    var scene : SKNode? = nil
    let cardScale = CGFloat(0.9)
    var cardTossDuration = 0.4
    let cardAnchorPoint = CGPoint(x: 0.5, y: UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ?
        -0.7 :
        -1.0)
    var fullHand = CGFloat(13)
    var sideOfTable = SideOfTable.Bottom
    var direction = Direction.Up
    var isFanClosed = false
    var isFanOpen :Bool { return !isFanClosed }
    var name = ""
    
    var position = CGPoint()
    
    subscript(index: Int) -> PlayingCard {
        return cards[index]
    }
    
    init(name:String)
    {
    self.name = name
    }
 
    func setup(scene:SKNode, direction: Direction, position: CGPoint, isUp: Bool = false, sizeOfCards: CardSize = CardSize.Small)
    {
        self.scene = scene
        self.direction = direction
        self.position = position
        self.isUp = isUp
        self.sizeOfCards = sizeOfCards
        self.isFanClosed = true
    }

    func append(card:PlayingCard)
    {
     
        cards.append(card)
        rearrangeFor(card, positionInSpread: 0,  fullHand: 1)
 
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
        cards.appendContentsOf(newCards)
        
        for card in cards
        {
            rearrangeFor(card, positionInSpread: 0,  fullHand: 1)
        }
     
    }
    func replaceWithContentsOf(newCards:[PlayingCard])
    {
        cards = newCards
        
        for card in cards
        {
        rearrangeFor(card, positionInSpread: 0,  fullHand: 1)
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
        if let sprite = CardSprite.spriteFor(card)
        {
            sprite.fan = self
            
            if (sprite.state != CardState.AtRest)
            {
                sprite.zPosition = 140
                sprite.state = CardState.AtRest
            }
            
            
            // Stop all running animations before starting new ones
         //   sprite.removeAllActions()
            sprite.positionInSpread = positionInSpread
            
            // PlayerOne's cards are larger
            
        
            let newScale =  sizeOfCards.scale
            
            let newHeight = newScale * sprite.size.height / sprite.yScale
            sprite.updateAnchorPoint(cardAnchorPoint)
            sprite.color = UIColor.whiteColor()
            sprite.colorBlendFactor = 0
            
            var flipAction = (SKAction.scaleTo(sizeOfCards.scale, duration: cardTossDuration))
            let newPosition =  positionOfCard(positionInSpread, spriteHeight: newHeight, fullHand:fullHand)
            let moveAction = (SKAction.moveTo(newPosition, duration:(cardTossDuration*0.8)))
            let rotationAngle = rotationOfCard(positionInSpread, fullHand:fullHand)
            let rotateAction = (SKAction.rotateToAngle(rotationAngle, duration:(cardTossDuration*0.8)))
            let scaleAction =  (SKAction.scaleTo(sizeOfCards.scale, duration: cardTossDuration))
            let scaleYAction =  SKAction.scaleYTo(sizeOfCards.scale, duration: cardTossDuration)
            var groupAction = SKAction.group([moveAction,rotateAction,scaleAction])
            
            if isUp && !sprite.isUp
            {
                //    sprite.flipUp()
                flipAction = (SKAction.sequence([
                    SKAction.scaleXTo(0.0, duration: cardTossDuration*0.5),
                    SKAction.runBlock({
                        sprite.flipUp()
                    }) ,
                    SKAction.scaleXTo(sizeOfCards.scale, duration: cardTossDuration*0.5)
                    ]))
                groupAction = SKAction.group([moveAction,rotateAction,flipAction,scaleYAction])
            }
            else if !isUp && sprite.isUp
            {
                // sprite.flipDown()
                flipAction = (SKAction.sequence([
                    SKAction.scaleXTo(0.0, duration: cardTossDuration*0.5),
                    SKAction.runBlock({
                        sprite.flipDown()
                    }) ,
                    SKAction.scaleXTo(sizeOfCards.scale, duration: cardTossDuration*0.5)
                    ]))
                groupAction = SKAction.group([moveAction,rotateAction,flipAction,scaleYAction])
            }
            
            sprite.runAction(SKAction.sequence([groupAction, SKAction.runBlock({
                sprite.zPosition = self.sizeOfCards.zOrder + positionInSpread
            }) ]))
          
      
        }
    }
    func rearrangeCardsAtRest()
    {
        if(scene==nil)
        {
            return
        }
        var fullHand = CGFloat(13)
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
            if let sprite = CardSprite.spriteFor(card)
                where sprite.state == CardState.AtRest
            {
                rearrangeFor(card,positionInSpread:positionInSpread, fullHand:fullHand)
            }
            positionInSpread++
            
        }
    }

    func reaZOrderCardsAtRest()
    {
        if(scene==nil)
        {
            return
        }
        var fullHand = CGFloat(13)
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
            if let sprite = CardSprite.spriteFor(card)
            where sprite.state == CardState.AtRest
            {
            sprite.zPosition = sizeOfCards.zOrder  + positionInSpread
            }
            positionInSpread++
            
        }
    }
    func rearrange()
    {
        if(scene==nil)
        {
            return
        }
        var fullHand = CGFloat(13)
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
            rearrangeFor(card,positionInSpread:positionInSpread, fullHand:fullHand)
            positionInSpread++
           
        }
    }
    
    
}


