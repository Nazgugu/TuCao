//
//  CDFeedViewController.m
//  吐槽百科
//
//  Created by Liu Zhe on 14/6/7.
//  Copyright (c) 2014年 CDFLS. All rights reserved.
//

#import "CDFeedViewController.h"
#import "NYSegmentedControl.h"
#import "FlatUIKit.h"
#import "CDTuCaoTableViewCell.h"

@interface CDFeedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong,nonatomic) NYSegmentedControl *topControl;
@end

@implementation CDFeedViewController
@synthesize topControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"59BAF3"];
    topControl = [[NYSegmentedControl alloc] initWithItems:@[@"新鲜",@"周边",@"热门"]];
    [topControl addTarget:self action:@selector(segmentControlChanged) forControlEvents:UIControlEventValueChanged];
    //topControl.borderColor = [UIColor colorWithWhite:0.20f alpha:1.0f];
    topControl.titleTextColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    topControl.selectedTitleTextColor = [UIColor whiteColor];
    topControl.segmentIndicatorBackgroundColor = [UIColor colorFromHexCode:@"00BDEF"];
    topControl.borderWidth = 1.0f;
    topControl.segmentIndicatorBorderWidth = 0.0f;
    topControl.segmentIndicatorInset = 1.0f;
    topControl.segmentIndicatorBorderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    [topControl sizeToFit];
    topControl.cornerRadius = CGRectGetHeight(topControl.frame) / 2.0f;
    topControl.borderColor = [UIColor whiteColor];
    topControl.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = topControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentControlChanged
{
    NSLog(@"selectedIndex = %ld",topControl.selectedSegmentIndex);
}

//tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDTuCaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuCao"];
    if (!cell)
    {
        NSLog(@"create new");
        cell = [[CDTuCaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tuCao"];
    }
    cell.avatarImage.image = [UIImage imageNamed:@"2a"];
    [cell.likeButton setTitle:@"25" forState:UIControlStateNormal];
    [cell.soWhatButton setTitle:@"10" forState:UIControlStateNormal];
    [cell.unhappyButton setTitle:@"5" forState:UIControlStateNormal];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
