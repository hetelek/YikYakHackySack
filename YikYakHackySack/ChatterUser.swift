 //
 //  ChatterUser.swift
 //  YikYakHackySack
 //
 //  Created by Stevie Hetelekides on 6/18/14.
 //  Copyright (c) 2014 Expetelek. All rights reserved.
 //
 
 import Foundation
 import CoreLocation
 
 class ChatterUser : NSObject, CLLocationManagerDelegate
 {
    // yik yak urls
    let baseUrl = "https://yikyakapp.com"
    let registerUrl = "/api/registerUser?userID=%@"
    let messagesUrl = "/api/getMessages?userID=%@&lat=%f&long=%f"
    let likeMessageUrl = "/api/likeMessage?messageID=%@&userID=%@"
    let downvoteMessageUrl = "/api/downvoteMessage?messageID=%@&userID=%@"
    let sendMessageUrl = "/api/sendMessage"
    let deleteMessageUrl = "/api/deleteMessage2?messageID=%d&userID=%@"
    let commentsUrl = "/api/getComments?messageID=%@&userID=%@"
    let postCommentUrl = "/api/postComment"
    let deleteCommentUrl = "/api/deleteComment?commentID=%@&userID=%@&messageID=%@"
    let likeCommentUrl = "/api/likeComment?commentID=%@&userID=%@"
    let downvoteCommentUrl = "/api/downvoteComment?commentID=%@&userID=%@"
    
    // variables
    var messages: [Message] = []
    var userID: String!
    var latitude, longitude: Double
    
    init(latitude: Double, longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
        super.init()
        
        // get a random user id
        self.userID = randomUserID()
    }
    
    init(latitude: Double, longitude: Double, userID: String)
    {
        self.latitude = latitude
        self.longitude = longitude
        self.userID = userID
    }
    
    func register() -> Bool
    {
        // create the url, make the request
        let userRegisterUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.registerUrl, self.userID))
        let registerResponse = getResponse(userRegisterUrl, headers: nil, postData: nil)
        
        // check if it returned 1
        if let registerResponseUnwrapped = registerResponse
        {
            return registerResponseUnwrapped == "1"
        }
        
        return false
    }
    
    func refreshMessages()
    {
        // clear all current messages
        self.messages.removeAll(keepCapacity: true)
        
        // create the url, make the request
        let userMessagesUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.messagesUrl, self.userID, self.latitude, self.longitude))
        let messagesResponse = getResponse(userMessagesUrl, headers: nil, postData: nil)
        
        if let messageResponseUnwrapped = messagesResponse
        {
            // get the data, and parse it as json
            let encodedData = messageResponseUnwrapped.dataUsingEncoding(NSUTF8StringEncoding)
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(encodedData!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary
            
            if let jsonObjectUnwrapped: AnyObject = jsonObject
            {
                // get all the messages
                let messages = jsonObjectUnwrapped["messages"] as [NSDictionary]
                for message in messages
                {
                    // parsae message data
                    let messageText = message["message"] as? String
                    let comments = message["comments"] as? Int
                    let deliveryID = message["deliveryID"] as? Int
                    let handle = message["handle"] as? String
                    let hidePin = message["hidePin"] as? String
                    let latitude = message["latitude"] as? Double
                    let longitude = message["longitude"] as? Double
                    let liked = message["liked"] as? Int
                    let messageID = message["messageID"] as? String
                    let numberOfLikes = message["numberOfLikes"] as? Int
                    let posterID = message["posterID"] as? String
                    let reyaked = message["reyaked"] as? Int
                    let time = message["time"] as? String
                    let type = message["type"] as? String
                    
                    // create the message object, append it to the array
                    let messageObject = Message(comments: comments, deliveryID: deliveryID, handle: handle, hidePin: hidePin?.toInt(), latitude: latitude, longitude: longitude, liked: liked, message: messageText, messageID: messageID, numberOfLikes: numberOfLikes, posterID: posterID, reyaked: reyaked, time: time, type: type?.toInt())
                    
                    self.messages.append(messageObject)
                }
            }
        }
    }
    
    func sendMessage(message: String, showExactLocation: Bool) -> Bool
    {
        // setup the post data
        let postData = "userID=\(self.userID)&lat=\(self.latitude)&long=\(self.longitude)&message=\(message)&hidePin=\(Int(!showExactLocation))"
        
        // create the url, make the request
        let userSendMessageUrl = self.baseUrl + ChatterAuthentication.signedUrl(self.sendMessageUrl)
        let sendMessageResponse = getResponse(userSendMessageUrl, headers: [ "Cookie": "userID=\(self.userID)" ], postData: postData)
        
        // see if it returned 1
        if let sendMessageResponseUnwrapped = sendMessageResponse
        {
            return sendMessageResponseUnwrapped == "1"
        }
        
        return false
    }
    
    func postComment(comment: String, message: Message) -> Bool
    {
        // setup the post data
        let postData = "userID=\(self.userID)&messageID=\(message.messageID!)&comment=\(comment)"
        
        // create the url, make the request
        let userPostCommentUrl = self.baseUrl + ChatterAuthentication.signedUrl(self.postCommentUrl)
        let postCommentResponse = getResponse(userPostCommentUrl, headers: [ "Cookie": "userID=\(self.userID)" ], postData: postData)
        
        // see if it returned 1
        if let postCommentResponseUnwrapped = postCommentResponse
        {
            return postCommentResponseUnwrapped == "1"
        }
        
        return false
    }
    
    func deleteComment(comment: Comment, message: Message)
    {
        // create the url, make the request
        let deleteCommentUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.deleteCommentUrl, comment.commentID!, self.userID, message.messageID!))
        getResponse(deleteCommentUrl, headers: [ "Cookie": "userID=\(self.userID)" ], postData: nil)
    }
    
    func likeComment(comment: Comment)
    {
        // create the url, make the request
        let userLikeCommentUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.likeCommentUrl, comment.commentID!, self.userID))
        getResponse(userLikeCommentUrl, headers: [ "Cookie": "userID=\(self.userID)" ], postData: nil)
    }
    
    func downvoteComment(comment: Comment)
    {
        // create the url, make the request
        let userDownvoteCommentUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.downvoteCommentUrl, comment.commentID!, self.userID))
        getResponse(userDownvoteCommentUrl, headers: [ "Cookie": "lat=\(self.latitude); long=\(self.longitude)" ], postData: nil)
    }
    
    func getComments(message: Message) -> [Comment]
    {
        // create a new array of comments
        var commentsArray: [Comment] = []
        
        // create the url, make the request
        let commentsUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.commentsUrl, message.messageID!, self.userID))
        let commentsResponse = getResponse(commentsUrl, headers: [ "Cookie": "userID=\(self.userID)" ], postData: nil)
        if let commentsResponseUnwrapped = commentsResponse
        {
            // parse the data as json
            let encodedData = commentsResponseUnwrapped.dataUsingEncoding(NSUTF8StringEncoding)
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(encodedData!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary
            
            if let jsonObjectUnwrapped: AnyObject = jsonObject
            {
                // get all the comments
                let comments = jsonObjectUnwrapped["comments"] as [NSDictionary]
                for comment in comments
                {
                    // parse the comments
                    let commentText = comment["comment"] as? String
                    let commentID = comment["commentID"] as? String
                    let liked = comment["liked"] as? Int
                    let numberOfLikes = comment["numberOfLikes"] as? Int
                    let posterID = comment["posterID"] as? String
                    let time = comment["time"] as? String
                    
                    // create the comment object, append it to the array
                    let commentObject = Comment(comment: commentText, commentID: commentID, liked: liked, numberOfLikes: numberOfLikes, posterID: posterID, time: time)
                    commentsArray.append(commentObject)
                }
            }
        }
        
        return commentsArray
    }
    
    func likeMessage(message: Message)
    {
        // create the url, make the request
        let userLikeMessageUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.likeMessageUrl, message.messageID!, self.userID))
        getResponse(userLikeMessageUrl, headers: [ "Cookie": "userID=\(self.userID)" ], postData: nil)
    }
    
    func downvoteMessage(message: Message)
    {
        // create the url, make the request
        let userDownvoteMessageUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.downvoteMessageUrl, message.messageID!, self.userID))
        getResponse(userDownvoteMessageUrl, headers: [ "Cookie": "userID=\(self.userID)" ], postData: nil)
    }
    
    func deleteMessage(message: Message)
    {
        // create the url, make the request
        let deleteMessageUrl = self.baseUrl + ChatterAuthentication.signedUrl(String(format: self.deleteMessageUrl, message.messageID!, self.userID))
        getResponse(deleteMessageUrl, headers: [ "Cookie": "userID=\(self.userID)" ], postData: nil)
    }
    
    func randomUserID() -> String
    {
        // setup the format and possible characters
        let userIDFormat = "00000000-0000-0000-0000-000000000000"
        let characters = [ "A", "B", "C", "D", "E", "F", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
        var userID = String()
        
        // loop through every character
        for character in userIDFormat
        {
            switch character
                {
                // if it's a 0, replace that with a random character
            case "0":
                let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
                userID += characters[randomIndex]
                
                // else, add the original character
            default:
                userID += String(character)
            }
        }
        
        return userID
    }
    
    func getResponse(url: String, headers: Dictionary<String, String>?, postData: String?) -> String?
    {
        // set up the mutable request (user-agent to YikYak's)
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url))
        request.addValue("Yik Yak/11 (iPhone; iOS 7.1.2; Scale/2.00)", forHTTPHeaderField: "User-Agent")
        request.addValue("en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5", forHTTPHeaderField: "Accept-Language")
        request.timeoutInterval = 3
        
        // add headers (if any)
        if let headersUnwrapped = headers
        {
            for (key: String, value: String) in headersUnwrapped
            {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // post body (if any)
        if let postDataUnwrapped = postData
        {
            request.HTTPMethod = "POST"
            request.HTTPBody = postDataUnwrapped.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        }
        
        // make the request, parse the data as a string
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if let dataUnwrapped = data
        {
            return NSString(data: dataUnwrapped, encoding: NSUTF8StringEncoding)
        }
        
        return nil
    }
 }