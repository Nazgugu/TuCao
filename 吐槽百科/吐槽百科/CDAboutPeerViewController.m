//
//  CDAboutPeerViewController.m
//  PeerChina
//
//  Created by Liu Zhe on 7/26/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDAboutPeerViewController.h"

@interface CDAboutPeerViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *aboutText;

@end

@implementation CDAboutPeerViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于Peer";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    //[self.aboutText setContentSize:CGSizeMake(self.aboutText.frame.size.width, 1200)];
    //NSLog(@"height = %f",self.aboutText.contentSize.height);
    //[self.aboutText.layoutManager ensureLayoutForTextContainer:self.aboutText.textContainer];
    //[self.aboutText layoutIfNeeded];
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
