//
//  ChatterAuthentication.swift
//  YikYakHackySack
//
//  Created by Stevie Hetelekides on 6/18/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

class ChatterAuthentication
{
    class func hmacString(string: String, salt: String, key: String) -> String
    {
        // get (key) and (string + salt) as NSData objects
        var keyData: NSData = key.dataUsingEncoding(NSUTF8StringEncoding)!
        var strData: NSData = (string + salt).dataUsingEncoding(NSUTF8StringEncoding)!
        
        // compute the sha1 hmac of it, return it base64 encoded
        let computedHMAC = HMAC.calculateWithAlgorithm(HMACAlgorithm.SHA1, key: keyData, data: strData)
        return computedHMAC.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    class func signedUrl(url: String) -> String
    {
        // get the salt (current time)
        let salt = String(format: "%d", Int(NSDate().timeIntervalSince1970))
        
        // hash the url with the salt and key
        var hash = ChatterAuthentication.hmacString(url, salt: salt, key: "F7CAFA2F-FE67-4E03-A090-AC7FFF010729")
        
        // encode the url
        let filters: Dictionary<String, String> = [ "/": "%2F", " ": "%20", "}": "%7D", "+": "%2B", "=": "%3D" ]
        for (key, value) in filters
        {
            hash = hash.stringByReplacingOccurrencesOfString(key, withString: value)
        }
        
        // add the computed salt and hash to the url
        if url.rangeOfString("?") != nil
        {
            return String(format: "%@&salt=%@&hash=%@", url, salt, hash)
        }
        else
        {
            return String(format: "%@?salt=%@&hash=%@", url, salt, hash)
        }
    }
}
