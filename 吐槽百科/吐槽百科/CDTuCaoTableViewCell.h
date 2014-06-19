//
//  CDTuCaoTableViewCell.h
//  吐槽百科
//
//  Created by Liu Zhe on 6/18/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDTuCaoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *soWhatButton;
@property (weak, nonatomic) IBOutlet UIButton *unhappyButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuCao;
@property (weak, nonatomic) IBOutlet UIButton *emojiButton;

@end
