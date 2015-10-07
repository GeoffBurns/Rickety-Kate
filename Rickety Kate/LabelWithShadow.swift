//
//  LabelWithShadow.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 7/10/2015.
//  Copyright © 2015 Geoff Burns All rights reserved.
//

import SpriteKit

class LabelWithShadow : SKLabelNode
{
    
    var topLabel = SKLabelNode()
    
    override var text : String? { didSet { topLabel.text = text }}
  // don't need to rotate as it is a child
  //  override var zRotation : CGFloat { didSet { topLabel.zRotation = zRotation }}
    override var fontSize : CGFloat { didSet { topLabel.fontSize = fontSize }}
    override var zPosition : CGFloat { didSet { topLabel.zPosition = zPosition-1.0 }}
    

    /////////////////////////////////////////////////////
    /// Constructors
    /////////////////////////////////////////////////////
    override init()
    {
        
        super.init()
        
        topLabel = SKLabelNode()
        // fontColor = UIColor.blackColor()
        
        fontColor = UIColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 0.7)
        topLabel.position = CGPoint(x:-2,y:2)
        topLabel.fontColor = UIColor.whiteColor()
        
        addChild(topLabel)
    }
    override init(fontNamed fontName: String!)
    {
     
        super.init(fontNamed:fontName)
        
        topLabel = SKLabelNode(fontNamed: fontName)
       // fontColor = UIColor.blackColor()
        
        fontColor = UIColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 0.7)
        topLabel.position = CGPoint(x:-2,y:2)
        topLabel.fontColor = UIColor.whiteColor()
       
        addChild(topLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

