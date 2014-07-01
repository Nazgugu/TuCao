//
//  CDDetailViewController.m
//  吐槽百科
//
//  Created by Liu Zhe on 7/1/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDDetailViewController.h"
#import "JBKenBurnsView.h"

@interface CDDetailViewController ()
@property (weak, nonatomic) IBOutlet JBKenBurnsView *images;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLayoutConstrait;

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
    self.contentTextLabel.text = self.contentText;
    CGRect textViewFrame = self.contentTextLabel.frame;
    NSDictionary *attribute = @{NSFontAttributeName:self.contentTextLabel.font};
    CGRect rect = [self.contentText boundingRectWithSize:CGSizeMake(textViewFrame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.detailScroll.contentSize = CGSizeMake(CGRectGetWidth(self.detailScroll.frame), CGRectGetMaxY(self.contentTextLabel.frame) + rect.size.height + 30);
    self.contentLayoutConstrait.constant = rect.size.height;
    [self.contentTextLabel layoutIfNeeded];
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
