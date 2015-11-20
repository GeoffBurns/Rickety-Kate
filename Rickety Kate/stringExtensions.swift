//
//  stringExtensions.swift
//  Sevens
//
//  Created by Geoff Burns on 18/11/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation



extension String
{
    func local(key:String) -> String
    {
      return NSLocalizedString(key, comment: self)
    }
    var localize : String
    {
        return NSLocalizedString(self, comment: self)
    }
    var localize_ : String
    {
    return NSLocalizedString(self.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil), comment: self)
    }
    var symbol : String
        { 
            if let codeObj = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode),
                code = codeObj as? String
             where code=="en"
            {
            return self
            }
            return self+"_symbol"
    }
    var isYou : Bool{
       return self=="You".localize
    }
    
}

