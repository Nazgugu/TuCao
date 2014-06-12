//
//  MBSwitch.h
//  MBSwitchDemo
//
//  Created by Mathieu Bolard on 22/06/13.
//  Copyright (c) 2013 Mathieu Bolard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSwitch : UIControl

@property(nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *onTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *offTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *thumbTintColor UI_APPEARANCE_SELECTOR;

@property(nonatomic,getter=isOn) BOOL on;

- (id)initWithFrame:(CGRect)frame;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
