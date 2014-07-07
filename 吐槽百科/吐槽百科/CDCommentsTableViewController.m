//
//  CDCommentsTableViewController.m
//  PeerChina
//
//  Created by Liu Zhe on 7/5/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDCommentsTableViewController.h"
#import "CDTCommentableViewCell.h"
#import "FlatUIKit.h"
#import "CDAppDelegate.h"

@interface CDCommentsTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSMutableArray *date;
@property (strong, nonatomic) CDTCommentableViewCell *commentCell;
@property (strong, nonatomic) NSString *objectID;
@end

@implementation CDCommentsTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationController.navigationBar.barTintColor = [UIColor turquoiseColor];
    self.title = @"评论";
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在更新" attributes:@{NSStrokeColorAttributeName:[UIColor grayColor]}];
    [refreshControl addTarget:self action:@selector(fetchContent) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.objectID = [[NSUserDefaults standardUserDefaults] objectForKey:objetcIDKey];
}

- (void)fetchContent
{
    //NSLog(@"objectID = %@",self.objectID);
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //PFFile *imageFile;
    formatter.dateFormat = @"yyyy-MM-dd";
    PFQuery *objectQuery = [PFQuery queryWithClassName:@"news"];
    //NSLog(@"scrollview content size 1 = %f",self.detailScroll.contentSize.height);
    [objectQuery getObjectInBackgroundWithId:self.objectID block:^(PFObject *object, NSError *error){
        if (!error)
        {
            if (object)
            {
                PFRelation *comments = [object relationForKey:@"userComments"];
                PFQuery *commentQuery = [comments query];
                [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
                   if (!error)
                   {
                       if (array)
                       {
                           if (!_comments)
                           {
                               _comments = [[NSMutableArray alloc] init];
                           }
                           if (!_date)
                           {
                               _date = [[NSMutableArray alloc] init];
                           }
                           [self.comments addObjectsFromArray:array];
                           for (int i = 0; i < array.count; i++)
                           {
                               PFObject *comment = [array objectAtIndex:i];
                               [self.date addObject:[formatter stringFromDate:comment.createdAt]];
                           }
                           [self.tableView reloadData];
                       }
                       [self.refreshControl endRefreshing];
                       [self.tableView setContentOffset:CGPointZero];
                   }
                }];
            }
        }
        else
        {
            [self.refreshControl endRefreshing];
            [self.tableView setContentOffset:CGPointZero];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"view did appear");
    [self fetchContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.commentCell)
    {
        self.commentCell = [self.tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    }
    NSString *avatarName = [[[self.comments objectAtIndex:indexPath.row] objectForKey:@"avatarNumber"] stringValue];;
    //NSLog(@"avatar name = %@",avatarName);
    NSString *nameString = [avatarName stringByAppendingString:@"a"];
    self.commentCell.avatarImage.image = [UIImage imageNamed:nameString];
    self.commentCell.userNameLabel.text = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"userName"];
    self.commentCell.timeLabel.text = [self.date objectAtIndex:indexPath.row];
    self.commentCell.commentBodyLabel.text = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"commentBody"];
    [self.commentCell setNeedsLayout];
    [self.commentCell layoutIfNeeded];
    CGFloat height = [self.commentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.comments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDTCommentableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[CDTCommentableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
    }
    // Configure the cell...
    NSString *avatarName = [[[self.comments objectAtIndex:indexPath.row] objectForKey:@"avatarNumber"] stringValue];
    NSString *nameString = [avatarName stringByAppendingString:@"a"];
    cell.avatarImage.image = [UIImage imageNamed:nameString];
    cell.userNameLabel.text = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"userName"];
    cell.timeLabel.text = [self.date objectAtIndex:indexPath.row];
    cell.commentBodyLabel.text = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"commentBody"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
