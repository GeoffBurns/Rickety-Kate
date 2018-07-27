//
//  Notice.swift
//  Rickety Kate
//
//  Copyright © 2018 Geoff Burns. All rights reserved.
//


import Cards

protocol Notice {
    
    var line1 : String? { get }
    var line2 : String? { get }
    var description : String? { get }
    
}


open class ShortNotice : ParameterizedString, Notice
{
    var description: String? { get { return self.localize } }
    
    var line2 : String? { get { return self.localize } }
    var line1 : String? { get { return ""} }
}

open class LongNotice : ParameterizedString, Notice
{
    var description: String? { get { return self.localize } }
    
    var line2 : String?
    {
        if let message = description {
            if message == "" {
                return ""
            }
            let messageLines = message.components(separatedBy: "\n")
            switch (messageLines.count) {
            case 1 :
                return message
            default :
                return messageLines[1]
            }
        }
        return nil
    }
    var line1 : String?
    {
        if let message = description {
            if message == "" {
                return ""
            }
            let messageLines = message.components(separatedBy: "\n")
            switch (messageLines.count) {
            case 1 :
                return ""
            default :
                return messageLines[0]
            }
        }
        return nil
    }
}
