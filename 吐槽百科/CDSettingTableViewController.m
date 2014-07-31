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
#import "FlatUIKit.h"
#import "ProgressHUD.h"
#import "UIColor+HTColor.h"

@interface CDSettingTableViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString *nameString;
@property (nonatomic) NSUInteger intName;
@property (weak, nonatomic) IBOutlet UISwitch *anonymousSwitch;

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

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor ht_aquaColor];
    self.title = @"设置";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey] boolValue] == YES)
    {
        self.nameLabel.text = @"匿名用户";
        [self.anonymousSwitch setOn:YES animated:YES];
    }
    else
    {
        self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey];
        [self.anonymousSwitch setOn:NO animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *avatarName = [[[NSUserDefaults standardUserDefaults] objectForKey:AvatarKey] stringValue];
    NSString *nameString = [avatarName stringByAppendingString:@"a"];
    [self.avatarImage setImage:[UIImage imageNamed:nameString]];
    //[self imageAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)imageAnimation
{
    CATransition *transition = [CATransition animation];
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = 1.5f;
    transition.type = @"rippleEffect";
    
    [[self.avatarImage layer] addAnimation:transition forKey:@"rippleEffect"];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"selected row at %ld",(long)indexPath.row);
    if (indexPath.section == 0)
    {
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
                                                             //NSLog(@"doing activity = %@, activityItems = %@", activity, activityItems);
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
    if (indexPath.row == 1)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"修改名称" message:@"请输入新昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        //alert.tag = 1;
        [alert show];
    }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 1) {  //Login
        [ProgressHUD show:@"正在更新名称" Interaction:NO];
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
            //NSLog(@"%@",username.text);
            [nickNameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                if (!error)
                {
                    //NSLog(@"%@",objects);
                    if (objects.count == 0)
                    {
                        //NSLog(@"situation 1");
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
                                [self.anonymousSwitch setOn:NO animated:YES];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                //[ProgressHUD dismiss];
                                [ProgressHUD showSuccess:@"设置成功"];
                                self.nameLabel.text = username.text;
                            }
                            else
                            {
                                [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:NickNameKey];
                                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AnonymousKey];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [self.anonymousSwitch setOn:NO animated:YES];
                                //[ProgressHUD dismiss];
                                [ProgressHUD showSuccess:@"暂时失败"];
                                [nameChange saveEventually];
                                self.nameLabel.text = username.text;
                                //perform the segue
                                //[self performSegueWithIdentifier:@"contents" sender:self];
                            }
                            //performsegue
                        }];
                    }
                    else
                    {
                        //NSLog(@"situation 2");
                        //have to check if the user using this nick name is the same as the current user, if it is then proceed to go to contents, else promt user to change to a different name
                        PFObject *tempObject = [objects lastObject];
                        //NSLog(@"tempObject[userKey] = %@",[tempObject[userKey] objectId]);
                        //NSLog(@"current user = %@",[PFUser currentUser].objectId);
                        if ([tempObject[@"username"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey]])
                        {
                            //NSLog(@"no collision");
                            //go ahead perform the segue
                            //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:isLoggedInKey];
                            [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:NickNameKey];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AnonymousKey];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self.anonymousSwitch setOn:NO animated:YES];
                            self.nameLabel.text = username.text;
                            //[ProgressHUD dismiss];
                            [ProgressHUD showSuccess:@"设置成功"];
                            //[self performSegueWithIdentifier:@"contents" sender:self];
                        }
                        else
                        {
                            //the nickname is take prompt the user to choose another one
                            //[ProgressHUD dismiss];
                            [ProgressHUD showError:@"重名咯～"];
                            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"重名啦" message:@"换个新名字吧～" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                            [alert show];
                            //[username becomeFirstResponder];
                        }
                    }
                }
                else
                {
                    [ProgressHUD showError:[error userInfo][@"error"]];
                    //NSLog(@": %@ %@", error, [error userInfo]);
                }
            }];
        }
    }
}

- (void)settingAvatarWithName:(NSString *)nameString andIntName:(NSInteger)intName
{
    [ProgressHUD show:@"正在更新" Interaction:NO];
    self.nameString = nameString;
    self.intName = intName;
    [PFUser currentUser][AvatarKey] = [NSNumber numberWithLong:intName];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error)
        {
            if (success)
            {
                /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"头像修改成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                alert.tag = 0;
                [alert show];*/
                //[ProgressHUD dismiss];
                [ProgressHUD showSuccess:@"设置成功" Interaction:NO];
                [self.avatarImage setImage:[UIImage imageNamed:self.nameString]];
                [self imageAnimation];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:self.intName] forKey:AvatarKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else
        {
            //[ProgressHUD dismiss];
            [ProgressHUD showError:@"出现了一点问题"];
        }
    }];
}

- (IBAction)toggleSwitch:(id)sender {
    //NSLog(@"UISwitch is now %",self.anonymousSwitch.isOn);
    if (self.anonymousSwitch.isOn)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:AnonymousKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.nameLabel.text = @"匿名用户";
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey]])
        {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"取个名字吧～" message:@"请输入昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            //alert.tag = 1;
            [alert show];
        }
        else
        {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:AnonymousKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:NickNameKey];
        }
    }
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
