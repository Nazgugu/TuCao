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
#import "ASCFlatUIColor.h"
#import "RQShineLabel.h"

static int count = 1;

@interface CDLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet FUIButton *noNameButton;
@property (weak, nonatomic) IBOutlet FUIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageLayer1;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *textArray;
@property (nonatomic) NSInteger textIndex;
@property (strong, nonatomic) FUITextField *nameField;
@property (strong, nonatomic) FUIButton *cancelButton;
@property (weak, nonatomic) IBOutlet RQShineLabel *shineLabel;
@property (nonatomic) BOOL isBlured;
@property (weak, nonatomic) IBOutlet UIView *topField;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
    self.imageArray = @[[UIImage imageNamed:@"loginImage"], [UIImage imageNamed:@"loginimage2"], [UIImage imageNamed:@"loginimage3"]];
    self.imageLayer1.image = [self.imageArray objectAtIndex:0];
    self.textArray = @[
                       @"我们都很孤单。",
                       @"在这深夜里是时候释放自己了。",
                       @"全部说出来吧。",
                       @"黑夜中最明亮的光，我们会听见你的心声。"
                       ];
    _textIndex = 0;
    self.shineLabel.backgroundColor = [UIColor clearColor];
    self.shineLabel.text = [self.textArray objectAtIndex:self.textIndex];
    [self.shineLabel sizeToFit];
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
    CGFloat topY = self.nickNameButton.center.y;
    self.nameField.hidden = YES;
    self.cancelButton.hidden = YES;
    [UIView animateWithDuration:0.2f animations:^{
        //self.noNameButton.center = CGPointMake(self.noNameButton.center.x, buttonY + 25);
        self.nickNameButton.center = CGPointMake(self.nickNameButton.center.x, topY + 25);
        [self.nickNameButton setTitle:@"让我开个小号" forState:UIControlStateNormal];
        self.nickNameButton.buttonColor = [UIColor clearColor];
        self.nickNameButton.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f].CGColor;
        self.nickNameButton.shadowColor = [UIColor silverColor];
        [self.nickNameButton setTitleColor:[[UIColor midnightBlueColor] colorWithAlphaComponent:0.3f] forState:UIControlStateNormal];
        [self.nickNameButton setNeedsDisplay];
        [self.view endEditing:YES];
    }
                     completion:^(BOOL complete)
     {
         if (complete)
         {
             self.isBlured = NO;
        }
     }];
}

- (IBAction)registerNickName:(id)sender {
    CGFloat topY = self.nickNameButton.center.y;
    //CGFloat buttonY = self.nickNameButton.center.y;
    if (!self.isBlured)
    {
        self.isBlured = YES;
        [UIView animateWithDuration:0.2f animations:^{
        //self.noNameButton.center = CGPointMake(self.noNameButton.center.x, buttonY + 25);
       self.nickNameButton.center = CGPointMake(self.nickNameButton.center.x, topY - 25);
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
    }
}

//handle keyboard
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    // the keyboard is hiding reset the table's height
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y += 160;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    // the keyboard is showing so resize the table's height
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y -= 160;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

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
                      duration:3.0f
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
