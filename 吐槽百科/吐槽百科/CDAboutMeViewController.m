//
//  CDAboutMeViewController.m
//  PeerChina
//
//  Created by Liu Zhe on 7/25/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#define URLEMail @"mailto:prada520farrell@gmail.com?subject=Bug Report&body="

#import "CDAboutMeViewController.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"

@interface CDAboutMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextView *meText;
@property (weak, nonatomic) IBOutlet HTPressableButton *emailButton;
@property (weak, nonatomic) IBOutlet HTPressableButton *appLinkButton;
@property (weak, nonatomic) IBOutlet HTPressableButton *linkedInButton;

@end

@implementation CDAboutMeViewController

- (void)loadView
{
    [super loadView];
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 15.0f)];
    UIImage *backImage = [UIImage imageNamed:@"back"]; //resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0f, 0, 12.0f)];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    //[backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

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
    self.title = @"About Me";
    // Do any additional setup after loading the view.
    self.avatarImage.layer.cornerRadius = 35.0f;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.image = [UIImage imageNamed:@"myAvatar"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.emailButton.style = HTPressableButtonStyleRounded;
    self.emailButton.buttonColor = [UIColor ht_jayColor];
    self.appLinkButton.style = HTPressableButtonStyleRounded;
    self.appLinkButton.buttonColor = [UIColor ht_emeraldColor];
    self.linkedInButton.style = HTPressableButtonStyleRounded;
    self.linkedInButton.buttonColor = [UIColor ht_lavenderColor];
}

- (IBAction)newEmail:(id)sender
{
    NSString *url = [URLEMail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)rateApp:(id)sender
{
    
}

- (IBAction)openWeb:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.linkedin.com/profile/view?id=297531322&trk=nav_responsive_tab_profile_pic"]];
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

@end
