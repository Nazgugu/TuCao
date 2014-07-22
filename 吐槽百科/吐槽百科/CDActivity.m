//
//  CDActivity.m
//  PeerChina
//
//  Created by Liu Zhe on 7/16/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDActivity.h"

@interface CDActivity()
@property (strong, nonatomic) NSString *activityTitle;
@property (strong, nonatomic) NSString *activityBody;
@property (strong, nonatomic) NSString *activityTime;
@property (strong, nonatomic) NSString *activityLocation;
@property (strong, nonatomic) NSMutableArray *goingPeople;
//@property (strong, nonatomic) PFRelation *peopleRelation;
@property (strong, nonatomic) PFObject *object;
@end

@implementation CDActivity
@synthesize activityTitle,activityBody,activityLocation,activityTime,goingPeople;

- (id)init
{
    self = [super init];
    if (self)
    {
        activityTitle = @"";
        activityBody = @"";
        activityTime = @"";
        activityLocation = @"";
        goingPeople = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addObject:(PFObject *)object
{
    self.object = object;
}

- (PFObject *)getObject
{
    return self.object;
}

- (void)addTitle:(NSString *)title
{
    activityTitle = title;
}

- (void)addBody:(NSString *)body
{
    activityBody = body;
}

- (void)addTime:(NSString *)date
{
    //implementation
    activityTime = date;
}

- (void)addLocation:(NSString *)location
{
    activityLocation = location;
}

- (void)addPeople:(CDPeople *)people
{
    [goingPeople addObject:people];
}

- (CDPeople *)getPeopleAtIndex:(NSInteger)index
{
    CDPeople *people = [goingPeople objectAtIndex:index];
    return people;
}

- (NSString *)getTitle
{
    return self.activityTitle;
}

- (NSString *)getBody
{
    return self.activityBody;
}

- (NSString *)getTime
{
    return self.activityTime;
}

- (NSString *)getLocation
{
    return self.activityLocation;
}

- (NSArray *)getPeople
{
    return self.goingPeople;
}

@end