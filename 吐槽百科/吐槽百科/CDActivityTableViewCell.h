//
//  CDActivityTableViewCell.h
//  PeerChina
//
//  Created by Liu Zhe on 7/15/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *user1;
@property (weak, nonatomic) IBOutlet UIImageView *user2;
@end
