//
//  CDAppDelegate.m
//  吐槽百科
//
//  Created by Liu Zhe on 6/6/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDAppDelegate.h"
#import <Parse/Parse.h>

@implementation CDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"SXIEzUxsT2N51VFP4qfBiDKDo8b7zCyN5QKJpKY5"
                  clientKey:@"OCx3rTWeeTunMYk3kd7I6iQFQ4pLzn7MbLV8ZJrx"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //check for necessary infomation
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey])
    {
        UIDevice *device = [UIDevice currentDevice];
        NSString *uniqueDeviceID = [[device identifierForVendor]UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uniqueDeviceID forKey:UserNameKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"匿名者" forKey:NickNameKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserLoginKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:UserLoginKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:RegisterKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:RegisterKey];
    }
    // Override point for customization after application launch.
    [self registerUser];
    NSLog(@"Unique user ID = %@",[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey]);
    return YES;
}

- (void)registerUser
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:RegisterKey] boolValue] == NO)
    {
        PFUser *newUser = [PFUser user];
        newUser.username = [[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey];
        newUser.password = PassWordKey;
        newUser[@"NickName"] = [[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey];
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError  *error) {
           if (!error)
           {
               NSLog(@"succeeded");
               [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:RegisterKey];
           }
            else
            {
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
                NSLog(@"error occurred: %@",errorString);
                [self loginUser];
            }
        }];
    }
}

- (void)loginUser
{
    [PFUser logInWithUsernameInBackground:[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey] password:PassWordKey block:^(PFUser *user, NSError *error){
        if (user)
        {
            NSLog(@"loggedIn Successful");
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:UserLoginKey];
        }
        else
        {
            NSLog(@"fatal error occured: %@, check server status",[error userInfo][@"error"]);
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
