//
//  CDDetailViewController.m
//  吐槽百科
//
//  Created by Liu Zhe on 7/1/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDDetailViewController.h"
#import "JBKenBurnsView.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "DCCommentView.h"
#import "FlatUIKit.h"
#import "BBBadgeBarButtonItem.h"
#import "CDAppDelegate.h"
#import "CDCommentsTableViewController.h"
#import "CDSingleton.h"
#import "ProgressHUD.h"

@interface CDDetailViewController ()<KenBurnsViewDelegate, DCCommentViewDelegate>
@property (weak, nonatomic) IBOutlet JBKenBurnsView *images;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLayoutConstrait;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (strong, nonatomic) NSMutableArray *animationImages;
@property (nonatomic) NSUInteger imageCount;
@property (strong, nonatomic) PFObject *news;
@property (strong, nonatomic) PFQuery *commentQuery;
@property (strong, nonatomic) DCCommentView *commentView;
@property (nonatomic) CGFloat height;
//@property (nonatomic) CGSize contentSize;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@end

@implementation CDDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view.
    self.images.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animates) name:@"completeDownloading" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctContentSizeHeight) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctContentSizeHeight) name:UIKeyboardDidHideNotification object:nil];
    //NSLog(@"THE CONTENT IS = %@",self.contentText);
    //NSLog(@"the object id is = %@",self.objectID);
    self.commentView = [DCCommentView new];
    self.commentView.delegate = self;
    self.commentView.tintColor = [UIColor peterRiverColor];
    BBBadgeBarButtonItem *commentButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:self.rightButton];
    commentButton.badgeBGColor = [UIColor emerlandColor];
    commentButton.badgeTextColor = [UIColor whiteColor];
    commentButton.shouldHideBadgeAtZero = NO;
    commentButton.badgeOriginX = 13;
    commentButton.badgeOriginY = -9;
    self.title = @"新闻";
    self.navigationItem.rightBarButtonItem = commentButton;
    //NSLog(@"view did load scrollview content size = %f",self.detailScroll.contentSize.height);
}

- (void)correctContentSizeHeight
{
    //NSLog(@"content size = %f",self.detailScroll.contentSize.height);
    [self performSelector:@selector(correct) withObject:nil afterDelay:0.1f];
}

- (void)correct
{
    [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.frame.size.width, self.height)];
}

- (IBAction)goToSegue:(id)sender {
    [self performSegueWithIdentifier:@"loadComments" sender:self];
}

- (void)animates
{
    if (self.animationImages.count == self.imageCount)
    {
        [self.loadingActivity stopAnimating];
        self.loadingActivity.hidden = YES;
        //NSLog(@"image count = %ld",(unsigned long)self.animationImages.count);
        [self.images animateWithImages:self.animationImages transitionDuration:6 initialDelay:0 loop:YES isLandscape:NO];
        //NSLog(@"after animating height = %f",self.detailScroll.contentSize.height);
    }
    //NSLog(@"scrollview content size = %f",self.detailScroll.contentSize.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexCode:@"59BAF3"];
    [[NSUserDefaults standardUserDefaults] setObject:self.objectID forKey:objetcIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"view did appear scrollview content size = %f",self.detailScroll.contentSize.height);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.commentView resignFirstResponder];
}

#pragma commentView delegate
- (void)didSendComment:(NSString *)text
{
    [self.commentView resignFirstResponder];
    [ProgressHUD show:@"正在发送" Interaction:NO];
    NSLog(@"comment text = %@",text);
    NSString *nameString;
    PFObject *comment = [PFObject objectWithClassName:@"comments"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey] boolValue] == YES)
    {
        nameString = @"匿名用户";
        comment[@"isAnonymous"] = [NSNumber numberWithBool:YES];
    }
    else
    {
        nameString = [[PFUser currentUser] objectForKey:NickNameKey];
        comment[@"isAnonymous"] = [NSNumber numberWithBool:NO];
    }
    comment[@"commentBody"] = text;
    comment[@"userName"] = nameString;
    comment[@"avatarNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:AvatarKey];
    PFRelation *commentRelation = [self.news relationForKey:@"userComments"];
    [comment saveInBackgroundWithBlock:^(BOOL success, NSError *error){
       if (success)
       {
           //NSLog(@"comment Succeeded");
           [commentRelation addObject:comment];
           [self.news saveInBackgroundWithBlock:^(BOOL successful, NSError *error){
              if (successful)
              {
                  NSLog(@"saved");
                  [ProgressHUD showSuccess:@"发送成功"];
              }
           }];
       }
    }];
}

- (void)didShowCommentView
{
    //NSLog(@"content size did show = %f",self.detailScroll.contentSize.height);
}

- (void)didDismissCommentView
{
    //NSLog(@"content size dismiss = %f",self.detailScroll.contentSize.height);
}

- (void)checkheight
{
    //NSLog(@"scrollview content size dismiss = %f",self.detailScroll.contentSize.height);
}

//
- (void)viewDidAppear:(BOOL)animated
{
    //self.contentTextLabel.text = self.contentText;
    //CGSize maxLabelSize = CGSizeMake(300, 9999);
    //NSLog(@"view did appear scrollview content size = %f",self.detailScroll.contentSize.height);
    [ProgressHUD show:@"正在载入" Interaction:NO];
    self.contentTextLabel.text = [CDSingleton globalData].content;
    //NSLog(@"contentText = %@",self.contentText);
    //NSLog(@"height 1 begining = %lf",CGRectGetMaxY(_contentTextLabel.frame));
    [self.contentTextLabel setNeedsLayout];
    [self.contentTextLabel layoutIfNeeded];
    NSDictionary *attribute = @{NSFontAttributeName:self.contentTextLabel.font};
    CGRect textViewFrame = self.contentTextLabel.frame;
    CGRect rect = [[CDSingleton globalData].content boundingRectWithSize:CGSizeMake(textViewFrame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    //NSLog(@"text = %@",self.contentText);
    //NSLog(@"rect height = %f",rect.size.height);
    self.contentLayoutConstrait.constant = rect.size.height;
    _detailScroll.contentSize = CGSizeMake(CGRectGetWidth(_detailScroll.frame), CGRectGetMaxY(_contentTextLabel.frame) + rect.size.height + 50);
    _height = CGRectGetMaxY(_contentTextLabel.frame) + rect.size.height + 50;
    //NSLog(@"height 1 = %lf",CGRectGetMaxY(_contentTextLabel.frame));
    //NSLog(@"height 2 = %lf",rect.size.height + 50);
    //NSLog(@"Before binding scrollview content size = %f",self.detailScroll.contentSize.height);
    //self.contentTextLabel.frame = textViewFrame;
    [self.commentView bindToScrollView:self.detailScroll superview:self.view];
    //NSLog(@"After binding scrollview content size = %f",self.detailScroll.contentSize.height);
    [self setUpAnimation];
}

- (void)setUpAnimation
{
    //NSLog(@"scrollview content size = %f",self.detailScroll.contentSize.height);
    self.loadingActivity.hidden = NO;
    [self.loadingActivity startAnimating];
    PFQuery *objectQuery = [PFQuery queryWithClassName:@"news"];
    //NSLog(@"scrollview content size 1 = %f",self.detailScroll.contentSize.height);
    [objectQuery getObjectInBackgroundWithId:self.objectID block:^(PFObject *object, NSError *error){
       if (!error)
       {
           self.detailScroll.contentSize = CGSizeMake(self.detailScroll.frame.size.width, self.height);
           [ProgressHUD dismiss];
           if (object)
           {
               //NSLog(@"scrollview content size 2 = %f",self.detailScroll.contentSize.height);
               //NSLog(@"got object");
               /*if (!self.news)
               {
                   self.news = [[PFObject alloc] init];
               }*/
               self.news = object;
               PFRelation *imagesRelation = [object relationForKey:@"imageArray"];
               PFRelation *commentRelation = [object relationForKey:@"userComments"];
               PFQuery *getComments = [commentRelation query];
               self.commentQuery = getComments;
               PFQuery *getImages = [imagesRelation query];
               //NSLog(@"scrollview content size 3 = %f",self.detailScroll.contentSize.height);
               [getComments findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
                {
                    if (!error)
                    {
                        if (comments)
                        {
                            BBBadgeBarButtonItem *button = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
                            button.badgeValue = [NSString stringWithFormat:@"%ld",(unsigned long)comments.count];
                            [getImages findObjectsInBackgroundWithBlock:^(NSArray *images, NSError *error){
                                if (!error)
                                {
                                    if (images)
                                    {
                                        //NSLog(@"got relational images");
                                        //NSLog(@"image count = %ld",(unsigned long)images.count);
                                        self.imageCount = images.count;
                                        for (int i = 0; i < images.count; i++)
                                        {
                                            PFFile *imageFile = [[images objectAtIndex:i] objectForKey:@"newsImage"];
                                            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                                                if (!error)
                                                {
                                                    if (data)
                                                    {
                                                        if (!self.animationImages)
                                                        {
                                                            self.animationImages = [[NSMutableArray alloc] init];
                                                        }
                                                        [self.animationImages addObject:[UIImage imageWithData:data]];
                                                        //[self.images addImage:[UIImage imageWithData:data]];
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"completeDownloading" object:self];
                                                        //NSLog(@"got one image");
                                                    }
                                                }
                                            }];
                                        }
                                        //[[NSNotificationCenter defaultCenter] postNotificationName:@"completeDownloading" object:self];
                                    }
                                }
                            }];

                        }
                    }
                }];
            }
       }
    }];
}

#pragma mark - KenBurnsViewDelegate

- (void)kenBurns:(JBKenBurnsView *)kenBurns didShowImage:(UIImage *)image atIndex:(NSUInteger)index
{
    //self.statuslabel.text = [NSString stringWithFormat:NSLocalizedString(@"Animating image %d (%.2f x %.2f)",),index,image.size.width, image.size.height];
}

- (void)kenBurns:(JBKenBurnsView *)kenBurns didFinishAllImages:(NSArray *)images
{
    //NSLog(@"Yay all done!");
}



#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES; // So that I can determine whether or not to perform the segue based on app logic
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareforSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"got called");
}


@end
