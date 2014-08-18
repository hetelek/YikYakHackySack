//
//  HMAC.m
//  YikYakHackySack
//
//  Created by Stevie Hetelekides on 6/9/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

#import "HMAC.h"
#import "YikYakHackySack-Swift.h"

@implementation HMAC
+ (NSData *)calculateWithAlgorithm:(HMACAlgorithm)algorithm key:(NSData *)key data:(NSData *)data
{
    NSInteger digestLength = [self digestLengthForAlgorithm:(HMACAlgorithm)algorithm];
    unsigned char hmac[digestLength];
    
    CCHmac(algorithm, key.bytes, key.length, data.bytes, data.length, &hmac);
    
    NSData *hmacBytes = [NSData dataWithBytes:hmac length:sizeof(hmac)];
    return hmacBytes;
}

+ (NSInteger)digestLengthForAlgorithm:(HMACAlgorithm)algorithm
{
    switch (algorithm)
    {
        case MD5: return CC_MD5_DIGEST_LENGTH;
        case SHA1: return CC_SHA1_DIGEST_LENGTH;
        case SHA224: return CC_SHA224_DIGEST_LENGTH;
        case SHA256: return CC_SHA256_DIGEST_LENGTH;
        case SHA384: return CC_SHA384_DIGEST_LENGTH;
        case SHA512: return CC_SHA512_DIGEST_LENGTH;
        default: return 0;
    }
}
@end
