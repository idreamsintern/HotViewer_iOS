//
//  SetBodyContent.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/14.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
    
    /// Populate the HTTPBody of `application/x-www-form-urlencoded` request
    ///
    /// :param: contentMap A dictionary of keys and values to be added to the request
    
    func setAPIBodyContent(contentMap: [String : String?], token: String) {
        var parameters = map(contentMap) { (key, value) -> String in
            if let val = value {
                return "\(key)=\(val.stringByAddingPercentEscapesForQueryValue()!)"
            } else {
                return ""
            }
        }
        parameters.append("token=\(token)")
        HTTPBody = "&".join(parameters).dataUsingEncoding(NSUTF8StringEncoding)
    }
}

extension String {
    
    /// Percent escape value to be added to a URL query value as specified in RFC 3986
    ///
    /// This percent-escapes all characters except the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Return precent escaped string.
    
    func stringByAddingPercentEscapesForQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        return stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
}
