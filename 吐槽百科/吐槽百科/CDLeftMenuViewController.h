//
//  CDLeftMenuViewController.h
//  吐槽百科
//
//  Created by Liu Zhe on 14/6/7.
//  Copyright (c) 2014年 CDFLS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"


@interface CDLeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@end
