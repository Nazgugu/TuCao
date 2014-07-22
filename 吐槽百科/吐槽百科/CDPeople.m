//
//  CDPeople.m
//  PeerChina
//
//  Created by Liu Zhe on 7/16/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDPeople.h"

@interface CDPeople()
@end

@implementation CDPeople
@synthesize name,avatarNumber;

- (id)init
{
    if (!self)
    {
        self = [super init];
    }
    name = @"";
    avatarNumber = 0;
    return self;
}

/*- (void)setName:(NSString *)name
{
    self.name = name;
}*/

@end
