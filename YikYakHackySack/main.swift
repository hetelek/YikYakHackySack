//
//  main.swift
//  YikYakHackySack
//
//  Created by Stevie Hetelekides on 6/9/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

// constants
let latitude = 43.009358
let longitude = -77.415410

// location randomness
let randLatitude = Double(arc4random_uniform(50)) / Double(arc4random_uniform(10000)) % 1
let randLongitude = Double(arc4random_uniform(50)) / Double(arc4random_uniform(10000)) % 1

// create a user with specified coordinates
let user = ChatterUser(latitude: latitude + randLatitude, longitude: longitude + randLongitude)

// register the user (becuase it's creating a random user id)
user.register()

// retrieve the messages
user.refreshMessages()

// loop through the messages, and print out information
for message in user.messages
{
    println(message.message!)
    println()
}