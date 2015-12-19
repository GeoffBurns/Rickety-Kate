//
//  GameViewController.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 10/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import UIKit
import SpriteKit
import iAd


class GameViewController: UIViewController , ADBannerViewDelegate {

    var adBannerView: ADBannerView = ADBannerView(frame: CGRect.zero)
    var gameScene : RicketyKateGameScene? = nil
    func loadAds(){
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.hidden = true
        self.canDisplayBannerAds = true
        view.addSubview(adBannerView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        // Detect the screensize
        let sizeRect = UIScreen.mainScreen().applicationFrame
        let scale = UIScreen.mainScreen().scale
        let width = sizeRect.size.width * scale
        let height = sizeRect.size.height * scale
        let size = CGSizeMake(width, height)

        // Scene should be shown in fullscreen mode
        let scene = RicketyKateGameScene(size: size)
        scene.tableSize = size

        // Configure the view.
        let skView = self.view as! SKView
            

        skView.showsFPS = false
        skView.showsNodeCount = false
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        
     
        scene.scaleMode = .ResizeFill
     
        scene.table = RicketyKateCardTable.makeDemo(scene)
            
        skView.presentScene(scene)
        
        gameScene = scene
        loadAds()
     
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
  
            return UIInterfaceOrientationMask.LandscapeLeft

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        GameSettings.sharedInstance.memoryWarning = true
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
   
    override  func viewWillTransitionToSize( _ size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    
    {
     resize(adBannerView,size: size);
  
    }
    
    
   func resize(banner: ADBannerView, size:CGSize = UIScreen.mainScreen().applicationFrame.size) {
        
        var adHeight = CGFloat()
        
        if adBannerView.hidden == false
        {
            adHeight = adBannerView.frame.size.height
        }
        
        if let scene = gameScene
        {
            let width = size.width //* UIScreen.mainScreen().scale
            let height = (size.height -  adHeight)// * UIScreen.mainScreen().scale
            let anchory = adHeight / height / 2.0
            let size = CGSizeMake(width, height)
            
            scene.anchorPoint = CGPointMake(0.0, anchory)
            scene.arrangeLayoutFor(size)
        }
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {

        resize(adBannerView);
    }
 //iAd
    func bannerViewWillLoadAd(banner: ADBannerView!) {

    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
       resize(banner);
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
          resize(banner);
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        
        return true 
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
      //   resize(banner);
    
}
}
