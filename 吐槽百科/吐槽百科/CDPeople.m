//
//  CDPeople.m
//  PeerChina
//
//  Created by Liu Zhe on 7/16/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDPeople.h"

@interface CDPeople()
@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger avatarNumber;
@end

@implementation CDPeople

- (id)init
{
    if (!self)
    {
        self = [super init];
    }
    self.name = @"";
    self.avatarNumber = 0;
    return self;
}

- (void)setName:(NSString *)name
{
    self.name = name;
}

- (void)setAvatarNumber:(NSInteger)avatarNumber
{
    self.avatarNumber = avatarNumber;
}

- (NSString *)getName
{
    return self.name;
}

- (NSInteger)getAvatarNumber
{
    return self.avatarNumber;
}

@end
