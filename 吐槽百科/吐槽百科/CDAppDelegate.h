//
//  CDAppDelegate.h
//  吐槽百科
//
//  Created by Liu Zhe on 6/6/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

//API KEYS
static NSString * const UserLoginKey = @"isLoggedIn";
static NSString * const UserNameKey = @"uniqueDeviceID";
static NSString * const NickNameKey = @"userNickName";
static NSString * const RegisterKey = @"isRegistered";
//static NSString * const nickNameOnServer = @"nickOnServer";
//static NSString * const tempName = @"temporaryName";
static NSString * const userKey = @"PFUser";
//default password
static NSString * const PassWordKey = @"defaultone";
//other
static NSString * const AnonymousKey = @"isAnonymoused";
static NSString * const isLoggedInKey = @"isLoggedIn";
static NSString * const locationOnKey = @"locationIsOn";
static NSString * const AvatarKey = @"userAvatar";

//post keys
static NSString * const postKey = @"TuCao";
static NSString * const postTextKey = @"postBody";
static NSString * const postTimeKey = @"postTime";
static NSString * const postLocationKey = @"postLocation";
static NSString * const postArray = @"posts";
static NSString * const thumbUpKey = @"happy";
static NSString * const soWhatKey = @"soWhat";
static NSString * const sympathyKey = @"sympathy";
static NSString * const commentsNumberKey = @"numberOfComments";
static NSString * const emotionKey = @"authorEmotion";


#import <UIKit/UIKit.h>

@interface CDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
