//
//  HMAC.h
//  YikYakHackySack
//
//  Created by Stevie Hetelekides on 6/9/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

typedef NS_ENUM(NSInteger, HMACAlgorithm)
{
    SHA1,
    MD5,
    SHA256,
    SHA384,
    SHA512,
    SHA224
};

@interface HMAC : NSObject
+ (NSData *)calculateWithAlgorithm:(HMACAlgorithm)algorithm key:(NSData *)key data:(NSData *)data;
@end
