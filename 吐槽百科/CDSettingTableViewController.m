//
//  CDSettingTableViewController.m
//  PeerChina
//
//  Created by Liu Zhe on 7/7/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDSettingTableViewController.h"
#import "CDAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "AAActivityAction.h"
#import "AAActivity.h"
#import <Parse/Parse.h>

@interface CDSettingTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CDSettingTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *avatarName = [[[NSUserDefaults standardUserDefaults] objectForKey:AvatarKey] stringValue];
    NSString *nameString = [avatarName stringByAppendingString:@"a"];
    [self.avatarImage setImage:[UIImage imageNamed:nameString]];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey] boolValue] == YES)
    {
        self.nameLabel.text = @"匿名用户";
    }
    else
    {
        self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row at %ld",(long)indexPath.row);
    if (indexPath.row == 0)
    {
        NSString *nameString;
        AAImageSize imageSize = AAImageSizeNormal;
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 1; i <= 81; i++)
        {
            nameString = [[NSString stringWithFormat:@"%ld",(long)i] stringByAppendingString:@"a"];
            AAActivity *activity = [[AAActivity alloc] initWithTitle:[@"头像" stringByAppendingFormat:@"%ld", (long)i]
                                                               image:[UIImage imageNamed:nameString]
                                                         actionBlock:^(AAActivity *activity, NSArray *activityItems) {
                                                             NSLog(@"doing activity = %@, activityItems = %@", activity, activityItems);
                                                             [self settingAvatarWithName:nameString andIntName:i];
                                                         }];
            [array addObject:activity];
        }
        AAActivityAction *aa = [[AAActivityAction alloc] initWithActivityItems:nil
                                                         applicationActivities:array
                                                                     imageSize:imageSize];
        aa.title = @"选择头像";
        [aa show];
    }
}

- (void)settingAvatarWithName:(NSString *)nameString andIntName:(NSInteger)intName
{
    [self.avatarImage setImage:[UIImage imageNamed:nameString]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:intName] forKey:AvatarKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [PFUser currentUser][AvatarKey] = [NSNumber numberWithLong:intName];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error)
        {
            if (success)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"头像修改成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}

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
