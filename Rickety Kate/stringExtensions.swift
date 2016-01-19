//
//  stringExtensions.swift
//  Sevens
//
//  Created by Geoff Burns on 18/11/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation

public class ParameterizedString
{
    let format : String
    let arguements : [CVarArgType]
    
    init(format:String, arguements : [CVarArgType] = [])
    {
        self.format = format
        self.arguements = arguements
    }

    var sayToYou :ParameterizedAlert
    {
        var newFormat = format
        if let range = newFormat.rangeOfString("%@")
        {
            newFormat.replaceRange(range, with: "You")
        }
        
        return  ParameterizedAlert(format: newFormat,arguements: arguements, isYou: true)
    }
    var sayTwiceToYou : ParameterizedAlert
    {
        let newFormat = format.stringByReplacingOccurrencesOfString("%@", withString: "You", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return  ParameterizedAlert(format: newFormat,arguements: arguements, isYou: true)
    }
    public func sayTwiceTo(name:String) -> ParameterizedAlert
    {
            if name.isYou {
                return self.sayTwiceToYou
            } else{
                var newArgs = arguements
                newArgs.append(name)
                
                newArgs.append(name)
                return ParameterizedAlert(format: format,arguements: newArgs)
        }
    }
    
    public func sayTo(name:String) -> ParameterizedAlert
    {
        if name.isYou {
            return self.sayToYou
        } else{
            var newArgs = arguements
      
            newArgs.append(name)
            return ParameterizedAlert(format: format,arguements: newArgs)
        }

    }
    public func using(arguements:CVarArgType...) -> ParameterizedString
    {
     
            var newArgs = self.arguements
            
            newArgs.appendContentsOf(arguements)
            return ParameterizedString(format: format,arguements: newArgs)
        
    }
    public func pluralize(n:Int,arguements : String...) -> ParameterizedString
    {
        if n==1 {
            let newFormat = format.stringByReplacingOccurrencesOfString("%d", withString: "a", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            var newArgs = Array(self.arguements)
            newArgs.appendContentsOf(arguements.map { $0 as CVarArgType })
            
            return ParameterizedString(format: newFormat,arguements: newArgs)
        } else{
            
            let newFormat = format            
            var newArgs = Array(self.arguements)
            newArgs.append(n)
            newArgs.appendContentsOf(arguements.map { ($0 + "s") as CVarArgType })
            
            return ParameterizedString(format: newFormat,arguements: newArgs)
        }
    }
    public func pluralizeUnit(n:Int, unit : String) -> ParameterizedString
    {
        let newFormat = format
        var newArgs = Array(self.arguements)
        newArgs.append(n)
        
        if n==1 {
            newArgs.append(unit)
        } else{
            newArgs.append(unit + "s")
        }
        
        return ParameterizedString(format: newFormat,arguements: newArgs)
    }
    public var localize : String
    {
            return String(format: format.localize, arguments: arguements)
    }
}
public struct WrappedParameterizedString
{
    var inner : ParameterizedString
    var outer : String
    var localize : String
     {
            return String(format: outer.localize, inner.localize)
    }
}

public class ParameterizedAlert : ParameterizedString
{
    var isYou :Bool;
    
    init(format:String, arguements : [CVarArgType] = [], isYou:Bool = false)
    {
        self.isYou = isYou
        super.init(format: format,arguements: arguements)
      
    }
    public override func using(arguements:CVarArgType...) -> ParameterizedAlert
    {
        
        var newArgs = self.arguements
        
        newArgs.appendContentsOf(arguements)
        return ParameterizedAlert(format: format,arguements: newArgs)
        
    }
    public var congrats : WrappedParameterizedString
    {
        if isYou
        {
            return WrappedParameterizedString(
                inner: ParameterizedString(format: format, arguements: arguements),
                outer: "Congratulatons %@")
        }
        return WrappedParameterizedString(
            inner: ParameterizedString(format: format, arguements: arguements),
            outer: "Wow %@")
    }
}

extension String
{
    public var with : ParameterizedString
    {
       return ParameterizedString(format: self, arguements: [])
    }
    public func localizeAs(key:String) -> String
    {
        return NSLocalizedString(key, comment: self)
    }
    public var underscore : String
    {
            return self.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    public var quote : String
    {
            return String(format: "\"%@\"",  self)
    }
    public func localizeWith(arguements:CVarArgType...) -> String
    {
        return String(format: self.localize, arguments: arguements)
    }
    public func localizeWith(arguements:[CVarArgType]) -> String
    {
        return String(format: self.localize, arguments: arguements)
    }
    public func sayToYou(name:String, arguements:[CVarArgType]) -> String
    {
        var format = self
        if let range = format.rangeOfString("%@")
        {
        format.replaceRange(range, with: "You")
        }
        
        return  format.localizeWith(arguements.tail)
    }
    public func sayTwiceToYou(name:String, arguements:[CVarArgType]) -> String
    {
        let format = self.stringByReplacingOccurrencesOfString("%@", withString: "You", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return  format.localizeWith(arguements.tail)
    }
    public func sayTwiceTo(arguements:CVarArgType...) -> String
    {
        if let name = arguements.first as? String
        {
            if name.isYou {
                return self.sayTwiceToYou(name,arguements: arguements)
            } else{
                var newArgs = Array(arguements)
                newArgs.append(name)
                return String(format: self.localize, arguments: newArgs)
            }
        }
        return String(format: self.localize, arguments: arguements)
    }

    public func sayTo(arguements:CVarArgType...) -> String
    {
        if let name = arguements.first as? String
            where name.isYou
        {
           return self.sayToYou(name,arguements: arguements)
        }
        return String(format: self.localize, arguments: arguements)
    }

    public func sayCongratsTo(name:String) -> String
    {
        
        return self.with.sayTo(name).congrats.localize
    }
    
    public var localize : String
    {
            return NSLocalizedString(self, comment: self)
    }
    

    var isYou : Bool{
       return self=="You".localize
    }
    
}

