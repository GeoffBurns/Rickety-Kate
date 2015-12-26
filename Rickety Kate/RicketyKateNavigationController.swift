//
//  RicketyKateNavigationController.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 20/12/2015.
//  Copyright © 2015 Nereids Gold. All rights reserved.
//

import UIKit

class RicketyKateNavigationController: UINavigationController {
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter() .
            addObserver(self, selector:
                Selector("showAuthenticationViewController"), name:
                PresentAuthenticationViewController, object: nil)
        
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
        super.viewDidLoad()
    }
    
    func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        
        if let authenticationViewController =
            gameKitHelper.authenticationViewController {
                
                topViewController! .
                    presentViewController(authenticationViewController,
                        animated: true,
                        completion: nil)
        }
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
