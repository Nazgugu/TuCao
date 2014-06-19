//
//  CDTuCaoTableViewCell.m
//  吐槽百科
//
//  Created by Liu Zhe on 6/18/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDTuCaoTableViewCell.h"

@implementation CDTuCaoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
