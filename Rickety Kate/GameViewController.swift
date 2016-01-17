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

    let transition = SKTransition.fadeWithDuration(1)
    var adBannerView: ADBannerView = ADBannerView(frame: CGRect.zero)

    func loadAds(){
        
        
    //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideBannerAd", name: "hideadsID", object: nil)
    //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "showBannerAd", name: "showadsID", object: nil)


        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.delegate = self
        adBannerView.hidden = true
        
       // set self.canDisplayBannerAds to true 
       // or use ADBannerView and ADBannerViewDelegate
       // don't do both
       // self.canDisplayBannerAds = true
        view.addSubview(adBannerView)
        
 //       NSNotificationCenter.defaultCenter().postNotificationName("showadsID", object: nil)
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
        
        NSNotificationCenter.defaultCenter() .
            addObserver(self, selector:
                Selector("showAuthenticationViewController"), name:
                PresentAuthenticationViewController, object: nil)
        
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
        
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
        
        loadAds()
     
    }
    
    
    func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        
        if let authenticationViewController =
            gameKitHelper.authenticationViewController {
                
              self  .
                    presentViewController(authenticationViewController,
                        animated: true,
                        completion: nil)
        }
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    /*
    func showBannerAd() {
        adBannerView.hidden = false
        resize(adBannerView)
        let bannerHeight = adBannerView.bounds.height
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1) // Time it takes the animation to complete
        adBannerView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - bannerHeight, 0, 0) // End position of the animation
        UIView.commitAnimations()
        NSLog("show Ad");
    }
    
    func hideBannerAd() {
        adBannerView.hidden = true
        
        let bannerHeight = adBannerView.bounds.height
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1) // Time it takes the animation to complete
        adBannerView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height + bannerHeight, 0, 0) // End position of the animation
        UIView.commitAnimations()
        resize(nil)
        NSLog("hide Ad");
    }

*/

   func resize(banner: ADBannerView?, size:CGSize = UIScreen.mainScreen().applicationFrame.size) {
        
        var adHeight = CGFloat()
    
       if let b = banner
     //     where b.bannerLoaded
        where b.hidden == false
        {
            adHeight = b.frame.size.height
       }
    if let uiView = self.view,
        skView = uiView as? SKView,
        scene = skView.scene as? RicketyKateGameScene
    {
        scene.adHeight = adHeight
        scene.arrangeLayoutFor(size,bannerHeight: adHeight)
        return
    }
    let   skViews = self.view.subviews.filter { $0 is SKView }
    if let uiView = skViews.first,
        skView = uiView as? SKView,
        scene = skView.scene as? RicketyKateGameScene
        {
            scene.adHeight = adHeight
            
            scene.arrangeLayoutFor(size,bannerHeight: adHeight)
        }
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {

        resize(adBannerView);
    }
 //iAd
    func bannerViewWillLoadAd(banner: ADBannerView!) {
         NSLog("banner will load");
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
       adBannerView.hidden = false
     /*   UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1) // Time it takes the animation to complete
        adBannerView.alpha = 1 // Fade in the animation
        UIView.commitAnimations() */
       resize(banner);
         NSLog("banner loaded");
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
      //   resize(banner);
         NSLog("banner Action Did Finish");
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        
        return true 
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
       adBannerView.hidden = true
    /*    UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        adBannerView.alpha = 0
        UIView.commitAnimations()*/
        let status = banner.bannerLoaded ? "error but banner loaded" :"banner unloaded"
        NSLog(status);
        
         resize(banner);
         NSLog(error.debugDescription);
    
}
}
