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
    func localizeAs(key:String) -> String
    {
        return NSLocalizedString(key.underscore, comment: self)
    }
    var underscore : String
        {
            return self.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    func localizeWith(arguements:CVarArgType...) -> String
    {
        return String(format: self.localize, arguments: arguements)
    }
    func localizeWith2(arguements:[CVarArgType]) -> String
    {
        return String(format: self.localize, arguments: arguements)
    }
    var localize : String
        {
            return NSLocalizedString(self.underscore, comment: self)
    }

    var symbol : String
        { 
       /*     if let codeObj = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode),
                code = codeObj as? String
             where code=="en"
            {
            return self
            }*/
            return self+"_symbol"
    }
    var isYou : Bool{
       return self=="You".localize
    }
    
}

