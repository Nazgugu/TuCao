//
//  CDLoginViewController.m
//  吐槽百科
//
//  Created by Liu Zhe on 6/6/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDLoginViewController.h"
#import "FlatUIKit.h"
#import "ASCFlatUIColor.h"

@interface CDLoginViewController ()
@property (weak, nonatomic) IBOutlet FUIButton *noNameButton;
@property (weak, nonatomic) IBOutlet FUIButton *nickNameButton;
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
    // Do any additional setup after loading the view.
    [self.noNameButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    self.noNameButton.buttonColor = [UIColor clearColor];
    self.noNameButton.layer.cornerRadius = 12.0f;
    self.noNameButton.layer.backgroundColor = [[UIColor concreteColor] colorWithAlphaComponent:0.1f].CGColor;
    self.noNameButton.highlightedColor = [[UIColor asbestosColor] colorWithAlphaComponent:0.2f];
    self.noNameButton.shadowColor = [[UIColor asbestosColor] colorWithAlphaComponent:0.6];
    self.noNameButton.cornerRadius = 12.0f;
    self.noNameButton.shadowHeight = 1.5f;
    [self.nickNameButton setTitleColor:[[UIColor midnightBlueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
    self.nickNameButton.buttonColor = [UIColor clearColor];
    self.nickNameButton.layer.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.5f].CGColor;
    self.nickNameButton.layer.cornerRadius = 12.0f;
    self.nickNameButton.highlightedColor = [[UIColor silverColor] colorWithAlphaComponent:0.8];
    self.nickNameButton.shadowColor = [UIColor silverColor];
    self.nickNameButton.shadowHeight = 1.5f;
    self.nickNameButton.cornerRadius = 12.0f;
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
