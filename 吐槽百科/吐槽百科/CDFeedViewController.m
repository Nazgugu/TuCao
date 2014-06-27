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
#import <Parse/Parse.h>

@interface CDFeedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong,nonatomic) NYSegmentedControl *topControl;
@property (strong, nonatomic) IBOutlet UITableView *newsTable;
@property (strong, nonatomic) CDTuCaoTableViewCell *newsCell;
@property (strong, nonatomic) NSMutableArray *newsTitle;
@property (strong, nonatomic) NSMutableArray *newsImage;
@property (strong, nonatomic) NSMutableArray *newsContent;
@property (strong, nonatomic) NSMutableArray *newsTime;
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
    [self fetchContent];
}

- (void)fetchContent
{
    NSDateFormatter *formatter;
    formatter.dateFormat = @"MM/DD/YYYY";
    PFQuery *newsQuery = [PFQuery queryWithClassName:@"news"];
    [newsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             if (!self.newsTitle)
             {
                 self.newsTitle = [[NSMutableArray alloc] init];
             }
             if (!self.newsImage)
             {
                 self.newsImage = [[NSMutableArray alloc] init];
             }
             if (!self.newsTime)
             {
                 self.newsTime = [[NSMutableArray alloc] init];
             }
             if (!self.newsContent)
             {
                 self.newsContent = [[NSMutableArray alloc] init];
             }
             [self.newsTitle removeAllObjects];
             [self.newsImage removeAllObjects];
             [self.newsTime removeAllObjects];
             [self.newsContent removeAllObjects];
             for (int i = 0; i < objects.count; i++)
             {
                 [self.newsTitle addObject:[[objects objectAtIndex:i] objectForKey:@"title"]];
                 [self.newsImage addObject:[UIImage imageWithData:[[objects objectAtIndex:i] objectForKey:@"image"]]];
                 [self.newsTime addObject:[formatter stringFromDate:[[objects objectAtIndex:i] objectForKey:@"createdAt"]]];
                 [self.newsTime addObject:[[objects objectAtIndex:i] objectForKey:@"content"]];
             }
         }
         else
         {
             
         }
     }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.newsCell)
    {
        self.newsCell = [self.newsTable dequeueReusableCellWithIdentifier:@"tuCao"];
    }
    self.newsCell.imageView.image = [self.newsImage objectAtIndex:indexPath.row];
    self.newsCell.newsTitle.text = [self.newsTitle objectAtIndex:indexPath.row];
    self.newsCell.newsTime.text = [self.newsTime objectAtIndex:indexPath.row];
    [self.newsCell setNeedsLayout];
    [self.newsCell layoutIfNeeded];
    //GET THE HEIGHT FOR THE CELL
    CGFloat height = [self.newsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //PADDING OF 1 POINT FOR THE SEPERATOR
    return  height + 1;
}

//load contents faster!
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109;
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
    cell.newsImage.image = [self.newsImage objectAtIndex:indexPath.row];
    cell.newsTitle.text = [self.newsTitle objectAtIndex:indexPath.row];
    cell.newsTime.text = [self.newsTime objectAtIndex:indexPath.row];
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
