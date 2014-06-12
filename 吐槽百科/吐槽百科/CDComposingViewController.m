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
#import "HMSegmentedControl.h"
#import "SZTextView.h"
#import <Parse/Parse.h>
#import "CDAppDelegate.h"
#import <AddressBookUI/AddressBookUI.h>

@interface CDComposingViewController ()<UITextViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet MBSwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet SZTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
//dealing with location
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;

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
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    self.locationSwitch.onTintColor = [ASCFlatUIColor emeraldColor];
    self.locationSwitch.offTintColor = [UIColor whiteColor];
    self.locationSwitch.thumbTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    self.locationSwitch.tintColor = [[ASCFlatUIColor cloudsColor] colorWithAlphaComponent:0.8f];
    [self.locationSwitch addTarget:self action:@selector(changedLocationPreference) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
    self.topView.backgroundColor = [ASCFlatUIColor wetAsphaltColor];
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
    [emotionSelection addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:emotionSelection];
    self.textView.placeholder = @"倾诉你的故事吧～!";
    self.textView.placeholderTextColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
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
