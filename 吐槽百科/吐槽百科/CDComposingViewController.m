//
//  CDComposingViewController.m
//  吐槽百科
//
//  Created by Liu Zhe on 14/6/11.
//  Copyright (c) 2014年 CDFLS. All rights reserved.
//

#import "CDComposingViewController.h"
#import "MBSwitch.h"
#import "HMSegmentedControl.h"
#import "SZTextView.h"
#import <Parse/Parse.h>
#import "CDAppDelegate.h"
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>
#import "FlatUIKit.h"

@interface CDComposingViewController ()<UITextViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet FUIButton *cancelButton;
@property (weak, nonatomic) IBOutlet FUIButton *postButton;
@property (weak, nonatomic) IBOutlet MBSwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet SZTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
//dealing with location
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nonatomic) NSInteger emotionSelection;
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
    self.locationText.text = @"位置已关闭";
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    self.locationSwitch.onTintColor = [UIColor turquoiseColor];
    self.locationSwitch.offTintColor = [UIColor whiteColor];
    self.locationSwitch.thumbTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    self.locationSwitch.tintColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8f];
    [self.locationSwitch addTarget:self action:@selector(changedLocationPreference) forControlEvents:UIControlEventValueChanged];
    //configure buttons
    self.cancelButton.buttonColor = [UIColor alizarinColor];
    self.cancelButton.shadowColor = [UIColor cloudsColor];
    self.cancelButton.highlightedColor = [UIColor pomegranateColor];
    self.cancelButton.shadowHeight = 1.0f;
    self.cancelButton.cornerRadius = 10.0f;
    self.postButton.buttonColor = [UIColor turquoiseColor];
    self.postButton.shadowColor = [UIColor cloudsColor];
    self.postButton.highlightedColor = [UIColor greenSeaColor];
    self.postButton.shadowHeight = 1.0f;
    self.postButton.cornerRadius = 10.0f;
    // Do any additional setup after loading the view.
    self.topView.backgroundColor = [UIColor colorFromHexCode:@"59BAF3"];
    HMSegmentedControl *emotionSelection = [[HMSegmentedControl alloc] initWithSectionImages:@[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"],[UIImage imageNamed:@"7"],[UIImage imageNamed:@"8"],[UIImage imageNamed:@"9"],[UIImage imageNamed:@"10"],[UIImage imageNamed:@"11"],[UIImage imageNamed:@"12"],[UIImage imageNamed:@"13"],[UIImage imageNamed:@"14"],[UIImage imageNamed:@"15"],[UIImage imageNamed:@"16"],[UIImage imageNamed:@"17"],[UIImage imageNamed:@"18"]] sectionSelectedImages:@[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"],[UIImage imageNamed:@"7"],[UIImage imageNamed:@"8"],[UIImage imageNamed:@"9"],[UIImage imageNamed:@"10"],[UIImage imageNamed:@"11"],[UIImage imageNamed:@"12"],[UIImage imageNamed:@"13"],[UIImage imageNamed:@"14"],[UIImage imageNamed:@"15"],[UIImage imageNamed:@"16"],[UIImage imageNamed:@"17"],[UIImage imageNamed:@"18"]]];
    emotionSelection.frame = CGRectMake(10, 75, 300, 35);
    emotionSelection.backgroundColor = [UIColor clearColor];
    emotionSelection.selectionStyle = HMSegmentedControlSelectionStyleBox;
    emotionSelection.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    emotionSelection.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    emotionSelection.userDraggable = YES;
    emotionSelection.touchEnabled = YES;
    emotionSelection.selectedSegmentIndex = HMSegmentedControlNoSegment;
    emotionSelection.type = HMSegmentedControlTypeImages;
    self.emotionSelection = -1;
    [emotionSelection addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:emotionSelection];
    self.textView.placeholder = @"倾诉你的故事吧～!";
    self.textView.placeholderTextColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    //setup avatar
    self.avatar.layer.cornerRadius = 18.0f;
    self.avatar.backgroundColor = [UIColor clearColor];
    [self setUpAvatar];
}

- (void)setUpAvatar
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey] boolValue] == YES)
    {
        self.avatar.image = [UIImage imageNamed:@"2a"];
    }
    else
    {
        NSString *imageNameString = [[[[NSUserDefaults standardUserDefaults] objectForKey:AvatarKey] stringValue] stringByAppendingString:@"a"];
        self.avatar.image = [UIImage imageNamed:imageNameString];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setUpLocationPreference];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
    locationManager.distanceFilter = 50.0f;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    [self updateLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [locationManager stopUpdatingLocation];
}

- (void) changedLocationPreference
{
    self.locationSwitch.on = self.locationSwitch.isOn;
    [self updateLocation];
}

- (void)setUpLocationPreference
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:locationOnKey] boolValue] == YES)
    {
        [self.locationSwitch setOn:YES animated:YES];
        [locationManager startUpdatingLocation];
    }
    else
    {
        [self.locationSwitch setOn:NO animated:YES];
        [locationManager stopUpdatingLocation];
    }
}

- (void)updateLocation
{
    if (self.locationSwitch.isOn == YES)
    {
        NSLog(@"location on");
        [locationManager startUpdatingLocation];
        CLLocation *currentLocation = locationManager.location;
        CLLocationCoordinate2D currentCoordinate = currentLocation.coordinate;
        self.latitude = currentCoordinate.latitude;
        self.longtitude = currentCoordinate.longitude;
        [self updateLocationText];
    }
    else
    {
        NSLog(@"location not on");
        [locationManager stopUpdatingLocation];
        [self setAddressWithAnimation:@"位置已隐藏"];
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    self.emotionSelection = segmentedControl.selectedSegmentIndex;
}

- (void)updateLocationText
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longtitude];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placeMarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocoding failed with error%@",error);
             [self setAddressWithAnimation:@"获取位置失败"];
         }
         else
         {
             NSLog(@"Can you see me in the completion block?");
             CLPlacemark *placeMark = placeMarks[0];
             NSDictionary *addressDict = placeMark.addressDictionary;
             NSString *addString = [NSString stringWithFormat:@"%@",ABCreateStringWithAddressDictionary(addressDict, YES)];
             addString = [addString stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
             //addString = [addString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
             NSLog(@"current address = %@",addString);
             [self setAddressWithAnimation:addString];
         }
     }];
}

- (void)setAddressWithAnimation:(NSString *)addString
{
    [UIView animateWithDuration:0.4f animations:^{
        self.locationText.text = @"";
        self.locationText.text = addString;
    }];
}

#pragma locationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",error);
    [self setAddressWithAnimation:@"获取位置失败"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"Location: %@",[locations lastObject]);
    NSLog(@"update to new location");
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D currentCoordinate = currentLocation.coordinate;
    if (currentLocation)
    {
        self.latitude = currentCoordinate.latitude;
        self.longtitude = currentCoordinate.longitude;
        [self updateLocationText];
    }
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

//posting to server
- (IBAction)postUpdate:(id)sender {
    //user have to select one emtion, how they feel about the thing they are about to share with others
    if (self.emotionSelection == -1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的心情是...?" message:@"你需要选择一个心情哦～" delegate:self cancelButtonTitle:@"知道啦！" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([self.textView.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"槽点不见啦" message:@"你需要写出来想吐槽的内容哦～" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //deal With GeoPoint
    PFGeoPoint *currentGeoPoint = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longtitude];
    //create posts object
    PFObject *postObject = [PFObject objectWithClassName:postKey];
    postObject[postTextKey] = self.textView.text;
    postObject[postTimeKey] = [NSDate date];
    postObject[postLocationKey] = currentGeoPoint;
    postObject[thumbUpKey] = @0;
    postObject[soWhatKey] = @0;
    postObject[sympathyKey] = @0;
    postObject[commentsNumberKey] = @0;
    postObject[AnonymousKey] = [[NSUserDefaults standardUserDefaults] objectForKey:AnonymousKey];
    postObject[locationOnKey] = [NSNumber numberWithBool:self.locationSwitch.isOn];
    postObject[emotionKey] = [NSNumber numberWithLong:self.emotionSelection];
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *author = [currentUser relationForKey:postArray];
    [postObject saveInBackgroundWithBlock:^(BOOL successful, NSError *someError)
     {
        if (successful)
        {
            [author addObject:postObject];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (succeeded)
                 {
                     [self performSegueWithIdentifier:@"unwind" sender:self];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"糟糕" message:@"貌似有点问题，一会儿帮你发吧～" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                     [alert show];
                     [currentUser saveEventually];
                     [self performSegueWithIdentifier:@"unwind" sender:self];
                 }
             }];
        }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"糟糕" message:@"貌似有点问题，一会儿帮你发吧～" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
             [alert show];
             [postObject saveEventually:^(BOOL done, NSError *fatalError){
                if (done)
                {
                    [author addObject:postObject];
                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                     {
                         if (succeeded)
                         {
                             [self performSegueWithIdentifier:@"unwind" sender:self];
                         }
                         else
                         {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"糟糕" message:@"貌似有点问题，一会儿帮你发吧～" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                             [alert show];
                             [currentUser saveEventually];
                             [self performSegueWithIdentifier:@"unwind" sender:self];
                         }
                     }];
                }
             }];
         }
     }];
    
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
