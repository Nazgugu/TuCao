//
//  CDSingleton.m
//  PeerChina
//
//  Created by Liu Zhe on 7/8/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDSingleton.h"

@implementation CDSingleton
@synthesize content;

+ (CDSingleton *)globalData
{
    static CDSingleton * theSingleton = nil;
    if (!theSingleton) {
        theSingleton = [[super allocWithZone:nil] init];
    }
    return theSingleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self globalData];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        content = @"";
    }
    return self;
}


@end
