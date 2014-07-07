//
//  CDSingleton.h
//  PeerChina
//
//  Created by Liu Zhe on 7/8/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDSingleton : NSObject
@property (strong, nonatomic) NSString *content;

+(CDSingleton *)globalData;
@end
