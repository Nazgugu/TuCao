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
#import "RQShineLabel.h"

static int count = 1;

@interface CDLoginViewController ()
@property (weak, nonatomic) IBOutlet FUIButton *noNameButton;
@property (weak, nonatomic) IBOutlet FUIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageLayer1;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *textArray;
@property (nonatomic) NSInteger textIndex;
@property (weak, nonatomic) IBOutlet RQShineLabel *shineLabel;
//@property (nonatomic) BOOL autoStart;
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
    self.noNameButton.layer.backgroundColor = [[UIColor concreteColor] colorWithAlphaComponent:0.3f].CGColor;
    self.noNameButton.highlightedColor = [[UIColor asbestosColor] colorWithAlphaComponent:0.2f];
    self.noNameButton.shadowColor = [[UIColor asbestosColor] colorWithAlphaComponent:0.6];
    self.noNameButton.cornerRadius = 12.0f;
    self.noNameButton.shadowHeight = 1.5f;
    [self.nickNameButton setTitleColor:[[UIColor midnightBlueColor] colorWithAlphaComponent:0.3f] forState:UIControlStateNormal];
    self.nickNameButton.buttonColor = [UIColor clearColor];
    self.nickNameButton.layer.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.5f].CGColor;
    self.nickNameButton.layer.cornerRadius = 12.0f;
    self.nickNameButton.highlightedColor = [[UIColor silverColor] colorWithAlphaComponent:0.8];
    self.nickNameButton.shadowColor = [UIColor silverColor];
    self.nickNameButton.shadowHeight = 1.5f;
    self.nickNameButton.cornerRadius = 12.0f;
    //self.autoStart = YES;
    self.imageArray = @[[UIImage imageNamed:@"loginImage"], [UIImage imageNamed:@"loginimage2"], [UIImage imageNamed:@"loginimage3"]];
    self.imageLayer1.image = [self.imageArray objectAtIndex:0];
    self.textArray = @[
                       @"With little time to talk, we all are children of loneliness.",
                       @"It is time to break the rule, put on your mask, no one has to know each other.",
                       @"Just speak out,  and we will hear your words.",
                       @"Through the darkest night come with the brightest light, today, your stories are heard"
                       ];
    _textIndex = 0;
    self.shineLabel.backgroundColor = [UIColor clearColor];
    self.shineLabel.text = [self.textArray objectAtIndex:self.textIndex];
    [self.shineLabel sizeToFit];
    //self.shineLabel.autoStart = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shineLabel shineWithCompletion:^{
        [self startAnimatingBackground];
    }];
}

/*- (void)Animate
{
    if (self.shineLabel.isVisible)
    {
        //NSLog(@"is visible");
        [self.shineLabel fadeOutWithCompletion:^{
            NSLog(@"text = %@",self.shineLabel.text);
            [self changeText];
            [self startAnimatingBackground];
            [self.shineLabel shineWithCompletion:^{
                [self Animate];
            }];
            //[self startAnimatingBackground];
        }];
    }
    else
    {
        [self.shineLabel shineWithCompletion:^{
        [self Animate];
        }];
    }
}*/

- (void)startAnimatingBackground
{
     dispatch_async(dispatch_get_main_queue(), ^{
         if (self.shineLabel.isVisible)
         {
             //NSLog(@"start animating background");
             UIImage *image = [self.imageArray objectAtIndex:(count % [self.imageArray count])];
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

- (void)changeText
{
    //NSLog(@"Text changed");
    //NSLog(@"text = %@",self.shineLabel.text);
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
