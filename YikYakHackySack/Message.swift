//
//  Message.swift
//  YikYakHackySack
//
//  Created by Stevie Hetelekides on 6/18/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

struct Message : Printable
{
    var comments: Int?
    var deliveryID: Int?
    var handle: AnyObject?
    var hidePin: Int?
    var latitude: Double?
    var longitude: Double?
    var liked: Int?
    var message: String?
    var messageID: String?
    var numberOfLikes: Int?
    var posterID: String?
    var reyaked: Int?
    var time: String?
    var type: Int?
    
    var description: String
    {
        let dataAsDictionary = [ "Comments": comments, "Delivery ID": deliveryID, "Handle": handle, "Hide Pin": hidePin, "Latitude": latitude, "Longitude": longitude, "Liked": liked, "Message": message, "Message ID": messageID, "Number Of Likes": numberOfLikes, "Poster ID": posterID, "Reyaked": reyaked, "Time": time, "Type": type ]
        return dataAsDictionary.description
    }
}