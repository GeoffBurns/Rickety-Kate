//
//  stringExtensions.swift
//  Sevens
//
//  Created by Geoff Burns on 18/11/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation

open class ParameterizedString
{
    let format : String
    let arguements : [CVarArg]
    
    init(format:String, arguements : [CVarArg] = [])
    {
        self.format = format
        self.arguements = arguements
    }

    var sayToYou :ParameterizedAlert
    {
        var newFormat = format
        if let range = newFormat.range(of: "%@")
        {
            newFormat.replaceSubrange(range, with: "You")
        }
        
        return  ParameterizedAlert(format: newFormat,arguements: arguements, isYou: true)
    }
    var sayTwiceToYou : ParameterizedAlert
    {
        let newFormat = format.replacingOccurrences(of: "%@", with: "You", options: NSString.CompareOptions.literal, range: nil)
        
        return  ParameterizedAlert(format: newFormat,arguements: arguements, isYou: true)
    }
    open func sayTwiceTo(_ name:String) -> ParameterizedAlert
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
    
    open func sayTo(_ name:String) -> ParameterizedAlert
    {
        if name.isYou {
            return self.sayToYou
        } else{
            var newArgs = arguements
      
            newArgs.append(name)
            return ParameterizedAlert(format: format,arguements: newArgs)
        }

    }
    open func using(_ arguements:CVarArg...) -> ParameterizedString
    {
     
            var newArgs = self.arguements
            
            newArgs.append(contentsOf: arguements)
            return ParameterizedString(format: format,arguements: newArgs)
        
    }
    open func pluralize(_ n:Int,arguements : String...) -> ParameterizedString
    {
        if n==1 {
            let newFormat = format.replacingOccurrences(of: "%d", with: "a", options: NSString.CompareOptions.literal, range: nil)
            
            var newArgs = Array(self.arguements)
            newArgs.append(contentsOf: arguements.map { $0 as CVarArg })
            
            return ParameterizedString(format: newFormat,arguements: newArgs)
        } else{
            
            let newFormat = format            
            var newArgs = Array(self.arguements)
            newArgs.append(n)
            newArgs.append(contentsOf: arguements.map { ($0 + "s") as CVarArg })
            
            return ParameterizedString(format: newFormat,arguements: newArgs)
        }
    }
    open func pluralizeUnit(_ n:Int, unit : String) -> ParameterizedString
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
    open var localize : String
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

open class ParameterizedAlert : ParameterizedString
{
    var isYou :Bool;
    
    init(format:String, arguements : [CVarArg] = [], isYou:Bool = false)
    {
        self.isYou = isYou
        super.init(format: format,arguements: arguements)
      
    }
    open override func using(_ arguements:CVarArg...) -> ParameterizedAlert
    {
        
        var newArgs = self.arguements
        
        newArgs.append(contentsOf: arguements)
        return ParameterizedAlert(format: format,arguements: newArgs)
        
    }
    open var congrats : WrappedParameterizedString
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
    public func localizeAs(_ key:String) -> String
    {
        return NSLocalizedString(key, comment: self)
    }
    public var underscore : String
    {
            return self.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
    }
    public var quote : String
    {
            return String(format: "\"%@\"",  self)
    }
    public func localizeWith(_ arguements:CVarArg...) -> String
    {
        return String(format: self.localize, arguments: arguements)
    }
    public func localizeWith(_ arguements:[CVarArg]) -> String
    {
        return String(format: self.localize, arguments: arguements)
    }
    public func sayToYou(_ name:String, arguements:[CVarArg]) -> String
    {
        var format = self
        if let range = format.range(of: "%@")
        {
        format.replaceSubrange(range, with: "You")
        }
        
        return  format.localizeWith(arguements.tail)
    }
    public func sayTwiceToYou(_ name:String, arguements:[CVarArg]) -> String
    {
        let format = self.replacingOccurrences(of: "%@", with: "You", options: NSString.CompareOptions.literal, range: nil)
        
        return  format.localizeWith(arguements.tail)
    }
    public func sayTwiceTo(_ arguements:CVarArg...) -> String
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

    public func sayTo(_ arguements:CVarArg...) -> String
    {
        if let name = arguements.first as? String, name.isYou
        {
           return self.sayToYou(name,arguements: arguements)
        }
        return String(format: self.localize, arguments: arguements)
    }

    public func sayCongratsTo(_ name:String) -> String
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

