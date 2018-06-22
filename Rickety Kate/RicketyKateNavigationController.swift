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
        NotificationCenter.default .
            addObserver(self, selector:
                #selector(RicketyKateNavigationController.showAuthenticationViewController), name:
                NSNotification.Name(rawValue: PresentAuthenticationViewController), object: nil)
        
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
        super.viewDidLoad()
    }
    
    @objc func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        
        if let authenticationViewController =
            gameKitHelper.authenticationViewController {
                
                topViewController! .
                    present(authenticationViewController,
                        animated: true,
                        completion: nil)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
