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
    
    override func setup(_ scene:SKNode)
    {
        self.gameScene = scene
        color = UIColor(red: 0.0, green: 0.3, blue: 0.1, alpha: 0.9)
        size = scene.frame.size
        var layoutSize = size
        position = CGPoint.zero
        anchorPoint = CGPoint.zero
        let fontsize : CGFloat = FontSize.medium.scale
        let leading : Int = Int(FontSize.medium.scale)
        isUserInteractionEnabled = true
        pageNo = 0
        if let resize = scene as? Resizable
        {
            self.adHeight = resize.adHeight
            layoutSize = CGSize(width: size.width, height: size.height - self.adHeight)
        }
        if isSetup
        {
         
        }
        else
        {
        rulesText  = SKMultilineLabel(
            text: Game.settings.rules.description,
            labelWidth: Int(layoutSize.width * 0.88),
            maxHeight:layoutSize.height * 0.75,
            pageBreak:layoutSize.height * 0.35,
            pos: CGPoint(x:layoutSize.width*0.5,
            y:layoutSize.height*0.8),
            fontSize:fontsize,
            fontColor:UIColor.white,
            leading:leading)
      
        name = PopupType.rulesScreen.description
  
        self.addChild(rulesText!)
   
        rulesText!.name = "RulesText"
        rulesText!.isUserInteractionEnabled = false
        tabNames = ["Rules","Deck","Scores"]
        
      
            cardDisplay.setup(self)
            isSetup = true
            displayButtons()
        }
 
        arrangeLayoutFor(layoutSize,bannerHeight: adHeight)
 
    
    }
    
    override func arrangeLayoutFor(_ size:CGSize,bannerHeight:CGFloat)
    {
        if let text = rulesText
        {
            text.dontUpdate = true
            text.labelWidth =  Int(size.width * 0.88)
            text.pos = CGPoint(x:size.width*0.5, y:size.height*0.8 + bannerHeight)
            text.labelHeightMax = size.height * 0.75
            text.pageBreak = size.height * 0.35
            text.dontUpdate = false
            text.update()
        }
        super.arrangeLayoutFor(size,bannerHeight:bannerHeight)
        
        let nodeNeedingLayoutRearrangement = self
            .children
            .filter { $0 is Resizable }
            .map { $0 as! Resizable }
        //      .filter { $0 is MultiPagePopup }
        //      .map { $0 as! MultiPagePopup }
        
        
        for resizing in nodeNeedingLayoutRearrangement
        {
            resizing.arrangeLayoutFor(size,bannerHeight:bannerHeight)
        }
    }
    override func noPageFor(_ tab:Int) -> Int
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
            self.tabNo += 1
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
