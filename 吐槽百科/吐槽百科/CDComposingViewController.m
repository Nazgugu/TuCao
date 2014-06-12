//
//  CDComposingViewController.m
//  吐槽百科
//
//  Created by Liu Zhe on 14/6/11.
//  Copyright (c) 2014年 CDFLS. All rights reserved.
//

#import "CDComposingViewController.h"
#import "MBSwitch.h"
#import "ASCFlatUIColor.h"

@interface CDComposingViewController ()
@property (weak, nonatomic) IBOutlet MBSwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation CDComposingViewController

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
    self.locationSwitch.onTintColor = [ASCFlatUIColor emeraldColor];
    self.locationSwitch.offTintColor = [UIColor whiteColor];
    self.locationSwitch.thumbTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    self.locationSwitch.tintColor = [[ASCFlatUIColor cloudsColor] colorWithAlphaComponent:0.8f];
    // Do any additional setup after loading the view.
    self.topView.backgroundColor = [ASCFlatUIColor wetAsphaltColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
