//
//  CDLoginViewController.m
//  吐槽百科
//
//  Created by Liu Zhe on 6/6/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDLoginViewController.h"
#import "FlatUIKit.h"
#import "FXBlurView.h"
#import "RQShineLabel.h"
#import <Accelerate/Accelerate.h>
#import <Parse/Parse.h>
#import "CDAppDelegate.h"
#import "Reachability.h"
#import "ProgressHUD.h"

static int count = 1;

@interface CDLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet FUIButton *noNameButton;
@property (weak, nonatomic) IBOutlet FUIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageLayer1;
@property (nonatomic) CGFloat textfieldPreviousY;
@property (nonatomic) CGFloat nameButtonPreviousY;
@property (nonatomic) CGFloat shiftedPosition;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *textArray;
@property (nonatomic) NSInteger textIndex;
@property (strong, nonatomic) FUITextField *nameField;
@property (strong, nonatomic) FUIButton *cancelButton;
@property (weak, nonatomic) IBOutlet RQShineLabel *shineLabel;
@property (nonatomic) BOOL isBlured;
@property (weak, nonatomic) IBOutlet UIView *topField;
//reachability check
@property (nonatomic) Reachability *netWorkConnection;
@end

@implementation CDLoginViewController

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
    //NSNotificationcenter
    // Do any additional setup after loading the view.
    [self.noNameButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    self.noNameButton.buttonColor = [UIColor clearColor];
    self.noNameButton.layer.cornerRadius = 12.0f;
    self.noNameButton.layer.backgroundColor = [[UIColor concreteColor] colorWithAlphaComponent:0.3f].CGColor;
    self.noNameButton.highlightedColor = [[UIColor asbestosColor] colorWithAlphaComponent:0.2f];
    self.noNameButton.shadowColor = [[UIColor asbestosColor] colorWithAlphaComponent:0.6];
    self.noNameButton.cornerRadius = 12.0f;
    self.noNameButton.shadowHeight = 1.5f;
    [self.nickNameButton setTitleColor:[[UIColor midnightBlueColor] colorWithAlphaComponent:0.3f] forState:UIControlStateNormal];
    self.nickNameButton.buttonColor = [UIColor clearColor];
    self.nickNameButton.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f].CGColor;
    self.nickNameButton.layer.cornerRadius = 12.0f;
    self.nickNameButton.highlightedColor = [[UIColor silverColor] colorWithAlphaComponent:0.8];
    self.nickNameButton.shadowColor = [UIColor silverColor];
    self.nickNameButton.shadowHeight = 1.5f;
    self.nickNameButton.cornerRadius = 12.0f;
    //NSLog(@"%f, %f",self.nickNameButton.center.x,self.nickNameButton.center.y);
    _isBlured = NO;
    //add namefield
    CGFloat yposition = self.nickNameButton.frame.origin.y;
    self.nameField = [[FUITextField alloc] initWithFrame:CGRectMake(50, yposition + 23 ,160, 30)];
    self.nameField.borderWidth = 1.0f;
    self.nameField.borderColor = [UIColor clearColor];
    self.nameField.cornerRadius = 12.0f;
    self.nameField.textFieldColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.5f];
    self.nameField.placeholder = @"输入昵称";
    self.nameField.hidden = YES;
    self.nameField.delegate = self;
    self.nameField.returnKeyType = UIReturnKeyDone;
    self.nameField.font = [UIFont systemFontOfSize:16];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.topField addSubview:self.nameField];
    //add cancel button
    self.cancelButton = [[FUIButton alloc] initWithFrame:CGRectMake(220, yposition + 23, 50, 30)];
    self.cancelButton.layer.backgroundColor = [[UIColor alizarinColor] colorWithAlphaComponent:0.7f].CGColor;
    [self.cancelButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    self.cancelButton.buttonColor = [UIColor clearColor];
    self.cancelButton.highlightedColor = [[UIColor alizarinColor] colorWithAlphaComponent:0.8f];
    self.cancelButton.cornerRadius = 12.0f;
    self.cancelButton.layer.cornerRadius = 12.0f;
    self.cancelButton.hidden = YES;
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(backToNormal:) forControlEvents:UIControlEventTouchUpInside];
    [self.topField addSubview:self.cancelButton];
    self.textfieldPreviousY = self.nameField.center.y;
    self.nameButtonPreviousY = self.nickNameButton.center.y;
    self.shiftedPosition = self.nickNameButton.center.y - 25;
    //NSLog(@"original textfield center position y = %f",self.textfieldPreviousY);
    //NSLog(@"original namebutton center position y = %f",self.nameButtonPreviousY);
    //NSLog(@"original shifted center position y = %f",self.shiftedPosition);
    self.imageArray = @[[UIImage imageNamed:@"loginImage"], [UIImage imageNamed:@"loginimage2"], [UIImage imageNamed:@"loginimage3"]];
    self.imageLayer1.image = [self.imageArray objectAtIndex:0];
    self.textArray = @[
                       @"PEER毅恒挚友计划，是致力于促进中国城乡教育公平、改善中国欠发达地区教育资源、并发展博雅、人文与素质教育的非营利组织。毅恒挚友的前身PEER挚友计划于2007年成立，2009年于美国马赛诸塞州波士顿市注册，2011年正式与友成企业家扶贫基金会设立专项基金。",
                       @"截至2012年8月，毅恒挚友在湖南、贵州、陕西、甘肃、广西和湖北的10所初高中累计举行了23次夏令营活动以及2次冬令营活动，总共有千余名中学生从中获益，“挚愿者”达到三百多名。从2011年春季开始，毅恒挚友亦致力于长期教育实验的开发与实践，在湖南省城步苗族自治县第一民族中学开展了第一期的“田野代言人”长期支教试点项目。截至2012年，已有三名“田野代言人”在湖南与贵州完成为期半年的支教活动。",
                       @"我们的愿景是希望中国所有的学生都能获得应有的教育，开发自身的潜力，了解社区的需求，共创中国的未来。为了达成这个愿景，长久以来，PEER毅恒挚友一直秉承着博雅、人文与素质教育的核心理念，在推动直接支教服务项目的基础上，全力开展相关的课程、教材开发与实践，努力带动地方社区服务领域的发展，并协助地方学校及老师共同探索更好服务学生的方法。",
                       @"最终，我们希望中国所有的学生无论在人生中选择走上何样的道路，都可以拥有自主、独立的思想与人生，取得理想的成果，并参与到其家乡与社区的发展中去。"
                       ];
    _textIndex = 0;
    self.shineLabel.backgroundColor = [UIColor clearColor];
    self.shineLabel.text = [self.textArray objectAtIndex:self.textIndex];
    self.shineLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.shineLabel sizeToFit];
    self.netWorkConnection = [Reachability reachabilityForInternetConnection];
    [self.netWorkConnection startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

//nectWork thing

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
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:connectionKey];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:connectionKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shineLabel shineWithCompletion:^{
        [self startAnimatingBackground];
    }];
}

- (IBAction)backToNormal:(id)sender
{
    //NSLog(@"original namebutton center position y = %f",self.nameButtonPreviousY);
    self.nameField.center = CGPointMake(self.nameField.center.x, self.textfieldPreviousY);
    self.cancelButton.center = CGPointMake(self.cancelButton.center.x, self.textfieldPreviousY);
    self.nameField.hidden = YES;
    self.cancelButton.hidden = YES;
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2f animations:^{
        self.nickNameButton.center = CGPointMake(self.nickNameButton.center.x, self.nameButtonPreviousY);
        [self.nickNameButton setTitle:@"让我开个小号" forState:UIControlStateNormal];
        self.nickNameButton.buttonColor = [UIColor clearColor];
        self.nickNameButton.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f].CGColor;
        self.nickNameButton.shadowColor = [UIColor silverColor];
        [self.nickNameButton setTitleColor:[[UIColor midnightBlueColor] colorWithAlphaComponent:0.3f] forState:UIControlStateNormal];
        [self.nickNameButton setNeedsDisplay];
    }
                     completion:^(BOOL complete)
     {
         if (complete)
         {
             self.isBlured = NO;
             self.nameField.text = @"";
        }
     }];
    //NSLog(@"original textfield center position y(shifted back to) = %f",self.nameField.center.y);
    //NSLog(@"original namebutton center position y(shifted back to) = %f",self.nickNameButton.center.y);
    //NSLog(@"original shifted center position y(shifted back to) = %f",self.cancelButton.center.y);
}

- (void)login
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserLoginKey] boolValue] == NO)
    {
        [PFUser logInWithUsernameInBackground:[[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey] password:PassWordKey];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:UserLoginKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)registerNickName:(id)sender {
    //CGFloat buttonY = self.nickNameButton.center.y;
    [self login];
    if (!self.isBlured)
    {
        self.isBlured = YES;
        [UIView animateWithDuration:0.2f animations:^{
        //self.noNameButton.center = CGPointMake(self.noNameButton.center.x, buttonY + 25);
       self.nickNameButton.center = CGPointMake(self.nickNameButton.center.x, self.nameButtonPreviousY - 25);
            [self.nickNameButton setTitle:@"就是它了" forState:UIControlStateNormal];
            self.nickNameButton.buttonColor = [UIColor clearColor];
            self.nickNameButton.shadowColor = [[UIColor emerlandColor] colorWithAlphaComponent:0.5f];
            self.nickNameButton.layer.backgroundColor = [[UIColor emerlandColor] colorWithAlphaComponent:0.3f].CGColor;
            [self.nickNameButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
            [self.nickNameButton setNeedsDisplay];
        } completion:^(BOOL complete){
            if (complete)
            {
                self.nameField.hidden = NO;
                self.cancelButton.hidden = NO;
            }
        }];
        NSLog(@"original namebutton center position y = %f",self.nameButtonPreviousY);
    }
    else
    {
        //dealing with empty name
        if ([self.nameField.text isEqualToString:@""])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能为空" message:@"请输入昵称" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            [self changeNameAndLogin];
        }
    }
}

//changeNameAndLogin
- (void)changeNameAndLogin{
    [self.nameField resignFirstResponder];
    [ProgressHUD show:@"正在处理" Interaction:NO];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:connectionKey] boolValue] == NO)
    {
        [ProgressHUD showError:@"网络故障"];
        return;
    }
    else
    {
        PFQuery *nickNameQuery = [PFUser query];
        [nickNameQuery whereKey:NickNameKey equalTo:self.nameField.text];
        NSLog(@"%@",self.nameField.text);
        [nickNameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (!error)
            {
                NSLog(@"%@",objects);
                if (objects.count == 0)
                {
                    NSLog(@"situation 1");
                    //ok to set this nickname since no one used it
                    PFUser *nameChange = [PFUser currentUser];
                    nameChange[NickNameKey] = self.nameField.text;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:isLoggedInKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [nameChange saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                         if (succeeded)
                         {
                             [ProgressHUD showSuccess:@"取名成功～"];
                             [self performSegueWithIdentifier:@"contents" sender:self];
                             [[NSUserDefaults standardUserDefaults] setObject:self.nameField.text forKey:NickNameKey];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                         }
                         else
                         {
                             [[NSUserDefaults standardUserDefaults] setObject:self.nameField.text forKey:NickNameKey];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             [ProgressHUD showSuccess:@"后台更新"];
                             [nameChange saveEventually];
                             //perform the segue
                             [self performSegueWithIdentifier:@"contents" sender:self];
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
                        [ProgressHUD showSuccess:@"取名成功～"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:isLoggedInKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self performSegueWithIdentifier:@"contents" sender:self];
                    }
                    else
                    {
                        //the nickname is take prompt the user to choose another one
                        [ProgressHUD showError:@"被占用咯～"];
                        [self.nameField becomeFirstResponder];
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

- (IBAction)anonymousLogin:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:connectionKey] boolValue] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无网络" message:[NSString stringWithFormat:@"无网络连接,请连接至互联网使用"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else
    {
        [self login];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey] boolValue] == NO)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:AnonymousKey];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:isLoggedInKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self performSegueWithIdentifier:@"contents" sender:self];
    }
}

//handle keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = self.nameField.frame;
    rect.origin.y = self.view.frame.size.height - 216 - 70;
    CGRect buttonRect = self.nickNameButton.frame;
    buttonRect.origin.y = self.view.frame.size.height - 216 - 120;
    CGRect cancelButtonRect = self.cancelButton.frame;
    cancelButtonRect.origin.y = self.view.frame.size.height - 216 - 70;
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.nickNameButton.frame = buttonRect;
    self.nameField.frame = rect;
    self.cancelButton.frame = cancelButtonRect;
    [UIView commitAnimations];
    NSLog(@"original namebutton center position y = %f",self.nameButtonPreviousY);
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        self.nameField.center = CGPointMake(self.nameField.center.x,self.textfieldPreviousY);
        self.cancelButton.center = CGPointMake(self.cancelButton.center.x, self.textfieldPreviousY);
        self.nickNameButton.center = CGPointMake(self.nickNameButton.center.x, self.shiftedPosition);
    }];
    
    return YES;
}

//touch outside to dismiss keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isBlured = NO;
    [self.view endEditing:YES];
}

//return to dismiss keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isKindOfClass:[FUITextField class]])
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

//animation
- (void)startAnimatingBackground
{
     dispatch_async(dispatch_get_main_queue(), ^{
         if (self.shineLabel.isVisible)
         {
             //NSLog(@"start animating background");
             UIImage *image = [self.imageArray objectAtIndex:(count % [self.imageArray count])];
             if (self.isBlured)
             {
                 image = [image blurredImageWithRadius:20.0f
                                              iterations:2
                                               tintColor:[UIColor cloudsColor]];
             }
            [UIView transitionWithView:self.imageLayer1
                      duration:4.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.shineLabel fadeOut];
                        self.imageLayer1.image = image;
                    }completion:^(BOOL finished)
              {
                  //NSLog(@"finished");
                  count++;
                  self.shineLabel.text = self.textArray[(++self.textIndex) % self.textArray.count];
                  [self.shineLabel shineWithCompletion:^{
                      [self startAnimatingBackground];
                  }];
              }];
         }
         else
         {
             [self.shineLabel shineWithCompletion:^{
                 [self startAnimatingBackground];}];
         }
     });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
