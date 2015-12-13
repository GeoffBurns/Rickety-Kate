//
//  RuleScreen.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

// Help Screen
class RuleScreen: MultiPagePopup {
    override var pageNo : Int  { didSet { if let text = rulesText { text.page = pageNo }}}
    var rulesText : SKMultilineLabel? = nil
    var cardDisplay = CardDisplayScreen()
      var isSetup = false
    
    override func setup(scene:SKNode)
    {
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        position = CGPointZero
        anchorPoint = CGPointZero
        let fontsize : CGFloat = FontSize.Medium.scale
        let leading : Int = Int(FontSize.Medium.scale)
        userInteractionEnabled = true
        pageNo = 0
        if isSetup
        {
            arrangeLayoutFor(size)
        }
        else
        {
        rulesText  = SKMultilineLabel(
            text: GameSettings.sharedInstance.rules.description,
            labelWidth: Int(scene.frame.width * 0.88),
            maxHeight:scene.frame.height * 0.75,
            pageBreak:scene.frame.height * 0.35,
            pos: CGPoint(x:CGRectGetMidX(scene.frame),
            y:scene.frame.size.height*0.8),
            fontSize:fontsize,
            fontColor:UIColor.whiteColor(),
            leading:leading)
      
        name = PopupType.RulesScreen.description
  
        self.addChild(rulesText!)
   
        rulesText!.name = "RulesText"
        rulesText!.userInteractionEnabled = false
        tabNames = ["Rules","Deck","Scores"]
        
      
            cardDisplay.setup(self)
            isSetup = true
        }
        
        displayButtons()

    }
    
    override func arrangeLayoutFor(size:CGSize)
    {
        self.size = size
        if let text = rulesText
        {
            text.dontUpdate = true
            text.labelWidth =  Int(size.width * 0.88)
            text.pos = CGPoint(x:size.width*0.5, y:size.height*0.8)
            text.labelHeightMax = size.height * 0.75
            text.pageBreak = size.height * 0.35
            text.dontUpdate = false
            text.update()
        }
        super.arrangeLayoutFor(size)
        
        let nodeNeedingLayoutRearrangement = self
            .children
            .filter { $0 is MultiPagePopup }
            .map { $0 as! MultiPagePopup }
        
        
        for resizing in nodeNeedingLayoutRearrangement
        {
            resizing.arrangeLayoutFor(size)
        }
    }
    override func noPageFor(tab:Int) -> Int
    {

        switch tab
        {
        case 0 :
            if let rulelines = rulesText
            {
                return rulelines.noOfPages
            }
            return 1
        case 1 :
            return cardDisplay.noPageFor(1)
        case 2 :
            
            return cardDisplay.noPageFor(2)
            
        default :
            return 1
        }
        
    }

    override func newPage() {
        if self.tabNo == 0
        {
           if self.pageNo >= rulesText!.noOfPages
           {
            self.tabNo++
            self.pageNo = 0
           }
     
            if self.pageNo < 0
            {
                self.tabNo = self.tabNames.count - 1
                self.pageNo = 0
            }
        }
        if self.tabNo > 0
        {
            cardDisplay.tabNo = self.tabNo
            cardDisplay.pageNo = self.pageNo
            cardDisplay.zPosition = 400
            addChild(cardDisplay)
            cardDisplay.newPage()
            return
        }
        self.rulesText!.page = self.pageNo
    }
   }
