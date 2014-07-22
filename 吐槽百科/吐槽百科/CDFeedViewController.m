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
#import "CDDetailViewController.h"
#import "ProgressHUD.h"
#import "CDAppDelegate.h"
#import "CDSingleton.h"
#import "CDActivity.h"
#import "CDPeople.h"
#import "CDActivityTableViewCell.h"

@interface CDFeedViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong,nonatomic) NYSegmentedControl *topControl;
@property (strong, nonatomic) IBOutlet UITableView *newsTable;
@property (strong, nonatomic) CDTuCaoTableViewCell *newsCell;
@property (strong, nonatomic) CDActivityTableViewCell *activityCell;
@property (strong, nonatomic) NSMutableArray *newsTitle;
@property (strong, nonatomic) NSMutableArray *newsImage;
@property (strong, nonatomic) NSMutableArray *newsContent;
@property (strong, nonatomic) NSMutableArray *newsTime;
@property (strong, nonatomic) NSMutableArray *newsID;
@property (strong, nonatomic) NSMutableArray *activities;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic) NSInteger count;
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

- (void)loadView
{
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.count = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"59BAF3"];
    topControl = [[NYSegmentedControl alloc] initWithItems:@[@"新闻",@"活动"]];
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
    //refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新" attributes:@{NSStrokeColorAttributeName:[UIColor grayColor]}];
    [refreshControl addTarget:self action:@selector(fetchContent) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self fetchContent];
}

- (void)reloadDataWithCount:(NSInteger)count
{
    //NSLog(@"count is = %ld",count);
    if (self.count - 1 == count)
    {
        //NSLog(@"reloading");
        [self.refreshControl endRefreshing];
        [self.tableView setContentOffset:CGPointZero];
        [self.newsTable reloadData];
    }
}

- (void)fetchContent
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:connectionKey] boolValue] == NO)
    {
        //[ProgressHUD dismiss];
        [ProgressHUD showError:@"无网络"];
        return;
    }
    if (topControl.selectedSegmentIndex == 0)
    {
    [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //PFFile *imageFile;
        formatter.dateFormat = @"yyyy-MM-dd";
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
             if (!self.newsID)
             {
                 self.newsID = [[NSMutableArray alloc] init];
             }
             if (objects.count > 0)
             {
                 self.count = objects.count;
                 //NSLog(@"self.count = %ld",(long)self.count);
                 //NSLog(@"I got something");
                 [self.newsTitle removeAllObjects];
                 [self.newsImage removeAllObjects];
                 [self.newsTime removeAllObjects];
                 [self.newsContent removeAllObjects];
                 [self.newsID removeAllObjects];
             for (int i = 0; i < objects.count; i++)
             {
                 PFFile *imageFile = [[objects objectAtIndex:i] objectForKey:@"image"];
                 [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                   if (!error)
                   {
                       if (data)
                       {
                           [self.newsImage addObject:[UIImage imageWithData:data]];
                           [self.newsTitle addObject:[[objects objectAtIndex:i] objectForKey:@"title"]];
                           PFObject *data = [objects objectAtIndex:i];
                           //NSDate *creation = data.createdAt;
                           //NSLog(@"date = %@",data.createdAt);
                           [self.newsTime addObject:[formatter stringFromDate:data.createdAt]];
                           //NSLog(@"created date = %@",self.newsTime[i]);
                           [self.newsContent addObject:[[objects objectAtIndex:i] objectForKey:@"content"]];
                           PFObject *news = [objects objectAtIndex:i];
                           [self.newsID addObject:news.objectId];
                           //NSLog(@"content = %@",self.newsContent[i]);
                           //NSLog(@"title = %@",self.newsTitle[i]);
                           [self reloadDataWithCount:i];
                       }
                   }
                 }];
                 //NSLog(@"done %d",i);
             }
            }
             else
             {
                 [self.refreshControl endRefreshing];
                 [self.tableView setContentOffset:CGPointZero];
             }
         }
         else
         {
             [ProgressHUD showError:@"发生了一些错误"];
         }
     }];
    }
    else if (topControl.selectedSegmentIndex == 1)
    {
        //NSLog(@"now activities");
        if (!_activities)
        {
            _activities = [[NSMutableArray alloc] init];
        }
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height)];
        [self.activities removeAllObjects];
        PFQuery *activityQuery = [PFQuery queryWithClassName:@"activity"];
        [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
           if (!error)
           {
               if (objects)
               {
                   //NSLog(@"got objects");
                   //NSLog(@"object count = %ld",objects.count);
                   self.count = objects.count;
                   for (int i = 0; i < objects.count; i++)
                   {
                       PFObject *object = [objects objectAtIndex:i];
                       CDActivity *newActivity = [[CDActivity alloc] init];
                       PFRelation *goingPeople = [object relationForKey:@"goPeople"];
                       PFQuery *peopleQuery = [goingPeople query];
                       [peopleQuery findObjectsInBackgroundWithBlock:^(NSArray *people, NSError *error){
                          if (!error)
                          {
                              if (people)
                              {
                                  //NSLog(@"got people");
                                  //NSLog(@"people count = %ld",people.count);
                                  for (int j = 0; j < people.count; j ++)
                                  {
                                      CDPeople *goingPeople = [[CDPeople alloc] init];
                                      NSString *name = [[people objectAtIndex:j] objectForKey:@"name"];
                                      NSInteger avatarNum = [[[people objectAtIndex:j] objectForKey:@"avatarNumber"] intValue];
                                      //[goingPeople setName:name];
                                      [goingPeople setName:name];
                                      [goingPeople setAvatarNumber:avatarNum];
                                      [newActivity addPeople:goingPeople];
                                  }
                                  NSString *title = [object objectForKey:@"title"];
                                  NSString *time = [object objectForKey:@"activityDate"];
                                  NSString *location = [object objectForKey:@"location"];
                                  NSString *body = [object objectForKey:@"body"];
                                  [newActivity addTitle:title];
                                  [newActivity addBody:body];
                                  [newActivity addTime:time];
                                  [newActivity addLocation:location];
                                  [newActivity addObject:object];
                                  [self.activities addObject:newActivity];
                                  [self reloadDataWithCount:i];
                              }
                          }
                        
                       }];
                   }
               }
               else
               {
                   [self.refreshControl endRefreshing];
                   [self.tableView setContentOffset:CGPointZero];
               }
           }
            else
            {
               [ProgressHUD showError:@"发生了一些错误"];
            }
        }];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentControlChanged
{
    NSLog(@"selectedIndex = %ld",(unsigned long)topControl.selectedSegmentIndex);
    [self.refreshControl endRefreshing];
    [self fetchContent];
}

//tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topControl.selectedSegmentIndex == 0)
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
        NSLog(@"height = %lf",height + 1);
        //PADDING OF 1 POINT FOR THE SEPERATOR
        return  height + 1;
    }
    else
    {
        if (!self.activityCell)
        {
            //NSLog(@"no cell");
            self.activityCell = [self.newsTable dequeueReusableCellWithIdentifier:@"activity"];
        }
        if (self.activityCell)
        {
            //NSLog(@"got cell");
        }
        CDActivity *activity = [self.activities objectAtIndex:indexPath.row];
        self.activityCell.titlelabel.text = [activity getTitle];
        self.activityCell.timeLabel.text = [activity getTime];
        self.activityCell.locationLabel.text = [activity getLocation];
        self.activityCell.bodyLabel.text = [activity getBody];
        NSArray *people = [activity getPeople];
        if (people.count >= 2)
        {
            CDPeople *user1 = [people objectAtIndex:0];
            CDPeople *user2 = [people objectAtIndex:1];
            NSString *nameString1 = [[NSString stringWithFormat:@"%ld",(long)user1.avatarNumber] stringByAppendingString:@"a"];
            NSString *nameString2 = [[NSString stringWithFormat:@"%ld",(long)user2.avatarNumber] stringByAppendingString:@"a"];
            [self.activityCell.user1 setImage:[UIImage imageNamed:nameString1]];
            [self.activityCell.user2 setImage:[UIImage imageNamed:nameString2]];
            self.activityCell.moreButton.hidden = NO;
        }
        else if (people.count == 0)
        {
            self.activityCell.moreButton.hidden = YES;
        }
        else
        {
            CDPeople *user = [people objectAtIndex:0];
            NSString *nameString = [[NSString stringWithFormat:@"%ld",(long)user.avatarNumber] stringByAppendingString:@"a"];
            [self.activityCell.user1 setImage:[UIImage imageNamed:nameString]];
            self.activityCell.moreButton.hidden = YES;
        }
        [self.activityCell setNeedsLayout];
        [self.activityCell layoutIfNeeded];
        CGFloat height = [self.activityCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        NSLog(@"height = %lf",height + 1);
        return height + 1;
    }
    return 0;
}


//load contents faster!
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
    if (topControl.selectedSegmentIndex == 0)
    {
        number = self.newsTitle.count;
    }
    else if (topControl.selectedSegmentIndex == 1)
    {
        number = self.activities.count;
    }
    return number;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (topControl.selectedSegmentIndex == 0)
    {
        CDTuCaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuCao"];
        if (!cell)
        {
            NSLog(@"create new");
            cell = [[CDTuCaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tuCao"];
        }
        cell.newsImage.image = [self.newsImage objectAtIndex:indexPath.row];
        if (self.newsImage[indexPath.row])
        {
            //NSLog(@"done image");
        }
        cell.newsTitle.text = [self.newsTitle objectAtIndex:indexPath.row];
        cell.newsTime.text = [self.newsTime objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        CDActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"activity"];
        if (!activityCell)
        {
            activityCell = [[CDActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activity"];
        }
        CDActivity *activity = [self.activities objectAtIndex:indexPath.row];
        activityCell.titlelabel.text = [activity getTitle];
        activityCell.timeLabel.text = [activity getTime];
        activityCell.locationLabel.text = [activity getLocation];
        activityCell.bodyLabel.text = [activity getBody];
        NSArray *people = [activity getPeople];
        if (people.count > 2)
        {
            NSLog(@"case 1");
            CDPeople *user1 = [people objectAtIndex:0];
            CDPeople *user2 = [people objectAtIndex:1];
            NSString *nameString1 = [[NSString stringWithFormat:@"%ld",(long)user1.avatarNumber] stringByAppendingString:@"a"];
            NSString *nameString2 = [[NSString stringWithFormat:@"%ld",(long)user2.avatarNumber] stringByAppendingString:@"a"];
            [activityCell.user1 setImage:[UIImage imageNamed:nameString1]];
            //[self imageAnimationWithImageView:activityCell.user1];
            [activityCell.user2 setImage:[UIImage imageNamed:nameString2]];
            //[self imageAnimationWithImageView:activityCell.user2];
            activityCell.moreButton.hidden = NO;
        }
        else if (people.count == 0)
        {
            NSLog(@"case 2");
            activityCell.moreButton.hidden = YES;
        }
        else if (people.count == 1)
        {
            NSLog(@"case 3");
            CDPeople *user = [people objectAtIndex:0];
            NSString *nameString = [[NSString stringWithFormat:@"%ld",(long)user.avatarNumber] stringByAppendingString:@"a"];
            NSLog(@"nameString = %@",nameString);
            [activityCell.user1 setImage:[UIImage imageNamed:nameString]];
            //[self imageAnimationWithImageView:activityCell.user1];
            activityCell.moreButton.hidden = YES;
        }
        else
        {
            NSLog(@"case 4");
            CDPeople *user1 = [people objectAtIndex:0];
            CDPeople *user2 = [people objectAtIndex:1];
            NSString *nameString1 = [[NSString stringWithFormat:@"%ld",(long)user1.avatarNumber] stringByAppendingString:@"a"];
            NSString *nameString2 = [[NSString stringWithFormat:@"%ld",(long)user2.avatarNumber] stringByAppendingString:@"a"];
            [activityCell.user1 setImage:[UIImage imageNamed:nameString1]];
            //[self imageAnimationWithImageView:activityCell.user1];
            [activityCell.user2 setImage:[UIImage imageNamed:nameString2]];
            //[self imageAnimationWithImageView:activityCell.user2];
            activityCell.moreButton.hidden = YES;
        }
        activityCell.goButton.buttonColor = [UIColor turquoiseColor];
        activityCell.goButton.shadowColor = [UIColor cloudsColor];
        activityCell.goButton.highlightedColor = [UIColor greenSeaColor];
        activityCell.goButton.shadowHeight = 1.0f;
        activityCell.goButton.cornerRadius = 7.0f;
        return activityCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topControl.selectedSegmentIndex == 0)
    {
        id detailVC = [self.splitViewController.viewControllers lastObject];
        if ([detailVC isKindOfClass:[UINavigationController class]])
            {
                detailVC  = [((UINavigationController *)detailVC).viewControllers firstObject];
                [self prepareViewController:detailVC forSegue:nil fromIndexPath:indexPath];
            }
    }
}

- (void)prepareViewController:(id)vc forSegue:(NSString *)segueIdentifier fromIndexPath:(NSIndexPath *)indexPath
{
    CDDetailViewController *detailNewsVC = (CDDetailViewController *)vc;
    //if ([[self.tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[CDTuCaoTableViewCell class]])
    //{
    [CDSingleton globalData].content = [self.newsContent objectAtIndex:indexPath.row];
        //detailNewsVC.contentText = [self.newsContent objectAtIndex:indexPath.row];
    //NSLog(@"newsContent = %@",detailNewsVC.contentText);
        detailNewsVC.objectID = [self.newsID objectAtIndex:indexPath.row];
    //NSLog(@"objectID = %@",detailNewsVC.objectID);
    //}
}

- (IBAction)wantToGo:(id)sender forEvent:(UIEvent *)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.newsTable];
    NSIndexPath *indexPath = [self.newsTable indexPathForRowAtPoint:location];
    self.indexPath = indexPath;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey] boolValue] == YES)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"需要名称才能加入" message:@"选择昵称" delegate:self cancelButtonTitle:nil otherButtonTitles:@"以前名称", nil];
        [alert addButtonWithTitle:@"新名称"];
        //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        //alert.tag = 1;
        alert.tag = 0;
        [alert show];
    }
    else
    {
        [ProgressHUD show:@"正在处理"];
        NSLog(@"user = %@",[PFUser currentUser]);
        if (indexPath)
        {
            [self wantToGoAtPoint:indexPath];
        }
    }
}

//delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        //NSLog(@"index = %ld",(long)buttonIndex);
        if (buttonIndex == 0)
        {
            //no nick name yet
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey]])
            {
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"还没有名字哦" message:@"取个名字吧～" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag = 1;
                [alert show];
            }
            else
            {
                [ProgressHUD show:@"正在处理"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AnonymousKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self wantToGoAtPoint:self.indexPath];
            }
        }
        else
        {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"换新名字咯～" message:@"请输入名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 1;
            [alert show];
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            [ProgressHUD show:@"正在处理" Interaction:NO];
            //rename and proceed
            UITextField *username = [alertView textFieldAtIndex:0];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:connectionKey] boolValue] == NO)
            {
                //[ProgressHUD dismiss];
                [ProgressHUD showError:@"无网络"];
                return;
            }
            else
            {
                PFQuery *nickNameQuery = [PFUser query];
                [nickNameQuery whereKey:NickNameKey equalTo:username.text];
                NSLog(@"%@",username.text);
                [nickNameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                    if (!error)
                    {
                        NSLog(@"%@",objects);
                        if (objects.count == 0)
                        {
                            NSLog(@"situation 1");
                            //ok to set this nickname since no one used it
                            PFUser *nameChange = [PFUser currentUser];
                            nameChange[NickNameKey] = username.text;
                            //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:isLoggedInKey];
                            //[[NSUserDefaults standardUserDefaults] synchronize];
                            [nameChange saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                if (succeeded)
                                {
                                    //[self performSegueWithIdentifier:@"contents" sender:self];
                                    [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:NickNameKey];
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AnonymousKey];
                                    //[self.anonymousSwitch setOn:NO animated:YES];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    //[ProgressHUD dismiss];
                                    //[ProgressHUD showSuccess:@"设置成功"];
                                    [self wantToGoAtPoint:self.indexPath];
                                    //self.nameLabel.text = username.text;
                                }
                                else
                                {
                                    [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:NickNameKey];
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AnonymousKey];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    //[self.anonymousSwitch setOn:NO animated:YES];
                                    //[ProgressHUD dismiss];
                                    //[ProgressHUD showSuccess:@"暂时失败"];
                                    [nameChange saveEventually];
                                    [self wantToGoAtPoint:self.indexPath];
                                    //self.nameLabel.text = username.text;
                                    //perform the segue
                                    //[self performSegueWithIdentifier:@"contents" sender:self];
                                }
                                //performsegue
                            }];
                        }
                        else
                        {
                            NSLog(@"situation 2");
                            //have to check if the user using this nick name is the same as the current user, if it is then proceed to go to contents, else promt user to change to a different name
                            PFObject *tempObject = [objects lastObject];
                            //NSLog(@"tempObject[userKey] = %@",[tempObject[userKey] objectId]);
                            //NSLog(@"current user = %@",[PFUser currentUser].objectId);
                            if ([tempObject[@"username"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey]])
                            {
                                NSLog(@"no collision");
                                //go ahead perform the segue
                                //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:isLoggedInKey];
                                [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:NickNameKey];
                                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AnonymousKey];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                //[self.anonymousSwitch setOn:NO animated:YES];
                                //self.nameLabel.text = username.text;
                                //[ProgressHUD dismiss];
                                //[ProgressHUD showSuccess:@"设置成功"];
                                [self wantToGoAtPoint:self.indexPath];
                                //[self performSegueWithIdentifier:@"contents" sender:self];
                            }
                            else
                            {
                                //the nickname is take prompt the user to choose another one
                                //[ProgressHUD dismiss];
                                [ProgressHUD showError:@"重名咯～"];
                                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"重名啦" message:@"换个新名字吧～" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                                alert.tag = 1;
                                [alert show];
                                //[username becomeFirstResponder];
                            }
                        }
                    }
                    else
                    {
                        NSLog(@": %@ %@", error, [error userInfo]);
                    }
                }];
            }
        }
        else
        {
            [ProgressHUD dismiss];
        }
    }
}

//implement for want to go
- (void)wantToGoAtPoint:(NSIndexPath *)indexPath
{
    PFRelation *relation = [[[self.activities objectAtIndex:indexPath.row] getObject] relationForKey:@"goPeople"];
    PFQuery *getPeople = [relation query];
    [getPeople whereKey:@"user" equalTo:[PFUser currentUser]];
    [getPeople findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error)
        {
            if (objects.count == 0)
            {
                //could involve
                PFObject *userGoing = [PFObject objectWithClassName:@"peopleInterested"];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey] boolValue] == YES)
                {
                    userGoing[@"name"] = @"匿名用户";
                }
                else
                {
                    userGoing[@"name"] = [[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey];
                }
                userGoing[@"avatarNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:AvatarKey];
                userGoing[@"user"] = [PFUser currentUser];
                [userGoing saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
                    if (succeed)
                    {
                        [relation addObject:userGoing];
                        [[[self.activities objectAtIndex:indexPath.row] getObject] saveInBackgroundWithBlock:^(BOOL successful, NSError *newError){
                            if (successful)
                            {
                                [ProgressHUD showSuccess:@"成功加入！"];
                                //reload this cell
                                CDPeople *newPeople = [[CDPeople alloc] init];
                                [newPeople setName:[[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey]];
                                [newPeople setAvatarNumber:[[[NSUserDefaults standardUserDefaults] objectForKey:AvatarKey] intValue]];
                                [[self.activities objectAtIndex:indexPath.row] addPeople: newPeople];
                                NSArray *indexArray = [NSArray arrayWithObject:indexPath];
                                [self.newsTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                            }
                        }];
                    }
                }];
            }
            else
            {
                [ProgressHUD showSuccess:@"重复选择"];
            }
        }
    }];
}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"get called");
     NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController forSegue:@"detail" fromIndexPath:indexPath];
}

@end
