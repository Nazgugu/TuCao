//
//  CDRootViewController.m
//  吐槽百科
//
//  Created by Liu Zhe on 14/6/7.
//  Copyright (c) 2014年 CDFLS. All rights reserved.
//

#import "CDRootViewController.h"
#import "CDLeftMenuViewController.h"
#import "UITableView+Wave.h"
#import "CDFeedViewController.h"
#import "CDSettingTableViewController.h"

@interface CDRootViewController ()

@end

@implementation CDRootViewController

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowRadius = 12.0f;
    self.contentViewShadowEnabled = YES;
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.backgroundImage = [UIImage imageNamed:@"sideMenu"];
    self.delegate = self;
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if ([self.contentViewController isKindOfClass:[UINavigationController class]])
        {
             UINavigationController *navigationController = (UINavigationController *)self.contentViewController;
             if ([navigationController.visibleViewController isKindOfClass:[CDFeedViewController class]])
             {
                 [userInfo setObject:@0 forKey:@"indexKey"];
             }
            if ([navigationController.visibleViewController isKindOfClass:[CDSettingTableViewController class]])
            {
                NSLog(@"its me here");
                [userInfo setObject:@1 forKey:@"indexKey"];
                NSLog(@"userinfo = %@",userInfo);
            }
            else
            {
                NSLog(@"not get it");
            }
         }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didShowSideView" object:self userInfo:userInfo];
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
    /*if ([menuViewController isKindOfClass:[CDLeftMenuViewController class]])
    {
        CDLeftMenuViewController* menuViewController = (CDLeftMenuViewController *)menuViewController;
        [menuViewController.tableView reloadDataAnimateWithWave];
    }*/
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}


@end
