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

@interface CDDetailViewController ()<KenBurnsViewDelegate, DCCommentViewDelegate>
@property (weak, nonatomic) IBOutlet JBKenBurnsView *images;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLayoutConstrait;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (strong, nonatomic) NSMutableArray *animationImages;
@property (nonatomic) NSUInteger imageCount;
@property (strong, nonatomic) PFObject *news;
@property (strong, nonatomic) DCCommentView *commentView;
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
    NSLog(@"THE CONTENT IS = %@",self.contentText);
    NSLog(@"the object id is = %@",self.objectID);
    self.commentView = [DCCommentView new];
    self.commentView.delegate = self;
    self.commentView.tintColor = [UIColor turquoiseColor];
}

- (void)animates
{
    if (self.animationImages.count == self.imageCount)
    {
        [self.loadingActivity stopAnimating];
        self.loadingActivity.hidden = YES;
        NSLog(@"image count = %ld",(unsigned long)self.animationImages.count);
        [self.images animateWithImages:self.animationImages transitionDuration:6 initialDelay:0 loop:YES isLandscape:NO];
    }
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
    [self.commentView bindToScrollView:self.detailScroll superview:self.view];
    NSLog(@"scrollview content size = %f",self.detailScroll.contentSize.height);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.commentView resignFirstResponder];
}

#pragma commentView delegate
- (void)didSendComment:(NSString *)text
{
    NSLog(@"comment text = %@",text);
}

- (void)viewDidAppear:(BOOL)animated
{
    //self.contentTextLabel.text = self.contentText;
    //CGSize maxLabelSize = CGSizeMake(300, 9999);
    NSDictionary *attribute = @{NSFontAttributeName:self.contentTextLabel.font};
    CGSize expectedSize = [self.contentText sizeWithAttributes:attribute];
    CGRect textViewFrame = self.contentTextLabel.frame;
    CGRect rect = [self.contentText boundingRectWithSize:CGSizeMake(textViewFrame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.detailScroll.contentSize = CGSizeMake(CGRectGetWidth(self.detailScroll.frame), CGRectGetMaxY(self.contentTextLabel.frame) + rect.size.height + 30);
    NSLog(@"scrollview content size = %f",self.detailScroll.contentSize.height);
    textViewFrame.size.height = expectedSize.height;
    self.contentLayoutConstrait.constant = rect.size.height;
    self.contentTextLabel.text = self.contentText;
    [self.contentTextLabel setNeedsLayout];
    [self.contentTextLabel layoutIfNeeded];
    [self setUpAnimation];
}

- (void)setUpAnimation
{
    self.loadingActivity.hidden = NO;
    [self.loadingActivity startAnimating];
    PFQuery *objectQuery = [PFQuery queryWithClassName:@"news"];
    [objectQuery getObjectInBackgroundWithId:self.objectID block:^(PFObject *object, NSError *error){
       if (!error)
       {
           if (object)
           {
               NSLog(@"got object");
               /*if (!self.news)
               {
                   self.news = [[PFObject alloc] init];
               }*/
               self.news = object;
               PFRelation *imagesRelation = [object relationForKey:@"imageArray"];
               PFQuery *getImages = [imagesRelation query];
               [getImages findObjectsInBackgroundWithBlock:^(NSArray *images, NSError *error){
                   if (!error)
                   {
                       if (images)
                       {
                           NSLog(@"got relational images");
                           NSLog(@"image count = %ld",(unsigned long)images.count);
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
                                          NSLog(@"got one image");
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

#pragma mark - KenBurnsViewDelegate

- (void)kenBurns:(JBKenBurnsView *)kenBurns didShowImage:(UIImage *)image atIndex:(NSUInteger)index
{
    //self.statuslabel.text = [NSString stringWithFormat:NSLocalizedString(@"Animating image %d (%.2f x %.2f)",),index,image.size.width, image.size.height];
}

- (void)kenBurns:(JBKenBurnsView *)kenBurns didFinishAllImages:(NSArray *)images
{
    NSLog(@"Yay all done!");
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
