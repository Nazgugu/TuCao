//
//  CDAppDelegate.m
//  吐槽百科
//
//  Created by Liu Zhe on 6/6/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDAppDelegate.h"
#import <Parse/Parse.h>
#import "Reachability.h"
#import "CDRootViewController.h"
#import "ProgressHUD.h"

@interface CDAppDelegate()
@property (nonatomic) Reachability *netWorkConnection;
@end

@implementation CDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"hFrIbEbJcgyMPiDs9ODFoAZNDCGKDamsbAWdAFMg"
                  clientKey:@"KOcdFIkHRTHrXk8bTPNw0TKTaCAGaCbPj1hGG2cJ"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:isLoggedInKey] boolValue]== YES)
    {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
    }
    //check for necessary infomation
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueDeviceID = [[device identifierForVendor]UUIDString];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:uniqueDeviceID forKey:UserNameKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:uniqueDeviceID forKey:NickNameKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserLoginKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:UserLoginKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:RegisterKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:RegisterKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AnonymousKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:isLoggedInKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:isLoggedInKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:locationOnKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:locationOnKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:AvatarKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:2] forKey:AvatarKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:connectionKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:connectionKey];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:objetcIDKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:objetcIDKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Override point for customization after application launch.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //NSLog(@"Unique user ID = %@",[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey]);
    return YES;
}

- (void)registerUser
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:RegisterKey] boolValue] == NO)
    {
        PFUser *newUser = [PFUser user];
        newUser.username = [[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey];
        newUser.password = PassWordKey;
        newUser[NickNameKey] = [[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey];
        newUser[AvatarKey] = [[NSUserDefaults standardUserDefaults] objectForKey:AvatarKey];
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError  *error) {
           if (!error)
           {
               NSLog(@"succeeded");
               [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:RegisterKey];
               [[NSUserDefaults standardUserDefaults] synchronize];
               /*
               PFUser *currentUser = [PFUser currentUser];
               PFObject *nickName = [PFObject objectWithClassName:nickNameOnServer];
               [nickName setObject:[[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey] forKey:tempName];
               [nickName setObject:currentUser forKey:userKey];
               [nickName saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                  if (error)
                  {
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                      [alertView show];
                      return;
                  }
                   else
                   {
                       //successful stored
                   }
               }];*/
               
           }
            else
            {
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
                //NSLog(@"error occurred: %@",errorString);
                [ProgressHUD showError:errorString];
                [self loginUser];
            }
        }];
    }
    else
    {
       [self loginUser]; 
    }
}

- (void)loginUser
{
    [PFUser logInWithUsernameInBackground:[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey] password:PassWordKey block:^(PFUser *user, NSError *error){
        if (user)
        {
            //NSLog(@"loggedIn Successful");
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:RegisterKey];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:UserLoginKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            //NSLog(@"fatal error occured: %@, check server status",[error userInfo][@"error"]);
            [ProgressHUD showError:[error userInfo][@"error"]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:UserLoginKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
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
    //check for network connectivity
    self.netWorkConnection = [Reachability reachabilityForInternetConnection];
    [self.netWorkConnection startNotifier];
    [self doSetUpWithReachability:self.netWorkConnection];
    /*if ([[[NSUserDefaults standardUserDefaults] objectForKey:isLoggedInKey] boolValue]== YES)
    {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
    }*/
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability *newStats = [note object];
    NSParameterAssert([newStats isKindOfClass:[Reachability class]]);
    [self doSetUpWithReachability:self.netWorkConnection];
}

- (void)doSetUpWithReachability:(Reachability *)reachability
{
    if (reachability == self.netWorkConnection)
    {
        NetworkStatus stats = [reachability currentReachabilityStatus];
        //NSlog(@"status = %@",stats);
        if (stats == NotReachable)
        {
            [ProgressHUD showError:@"无网络"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:connectionKey];
        }
        else
        {
            NSLog(@"network connection is established");
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:connectionKey];
            [self registerUser];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
