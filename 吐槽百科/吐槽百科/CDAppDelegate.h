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
static NSString * const nickNameOnServer = @"nickOnServer";
static NSString * const tempName = @"temporaryName";
static NSString * const userKey = @"PFUser";
//default password
static NSString * const PassWordKey = @"defaultone";
static NSString * const AnonymousKey = @"isAnonymoused";

#import <UIKit/UIKit.h>

@interface CDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
