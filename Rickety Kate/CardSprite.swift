//
//  CardSprite.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Nereids Gold. All rights reserved.
//


import SpriteKit

class CardSprite : SKSpriteNode
{
    static var register : Dictionary<String, CardSprite> = [:]

    weak var fan : CardPile? = nil
    weak var player : CardPlayer? = nil
    var card : PlayingCard
    var isUp = false
    var positionInSpread = CGFloat(0.0)
    
    init(card:PlayingCard, player : CardPlayer)
    {
   
    self.card = card
        self.player = player
        
    let back =  SKTexture(imageNamed: "Back1")
    super.init(texture: back, color: UIColor.whiteColor(), size: back.size())
      

    self.name = card.imageName
    self.userInteractionEnabled = false    
    CardSprite.register.updateValue( self, forKey: card.imageName)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    
    func flipUp()
    {
        if !isUp
        {
            texture = SKTexture(imageNamed: name!)
            isUp = true
        }
    }
    func flipDown()
    {
        if isUp
        {
            texture = SKTexture(imageNamed: "Back1")
            isUp = false

        }
    }
    
    static func spriteFor(card :PlayingCard) -> CardSprite?
    {
        return CardSprite.register[card.imageName]
    }
    static func sprite(card :PlayingCard) -> CardSprite
    {
        return CardSprite.register[card.imageName]!
    }
    
}