//
//  CDActivity.h
//  PeerChina
//
//  Created by Liu Zhe on 7/16/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDPeople.h"
#import <Parse/Parse.h>

@interface CDActivity : NSObject

- (void)addTitle:(NSString *)title;
- (void)addBody:(NSString *)body;
- (void)addTime:(NSString *)date;
- (void)addLocation:(NSString *)location;
- (void)addPeople:(CDPeople *)people;
- (void)addObject:(PFObject *)object;
- (CDPeople *)getPeopleAtIndex:(NSInteger)index;
- (NSString *)getTitle;
- (NSString *)getBody;
- (NSString *)getTime;
- (NSString *)getLocation;
- (NSArray *)getPeople;
- (PFObject *)getObject;
@end