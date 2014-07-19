//
//  CDActivityTableViewCell.m
//  PeerChina
//
//  Created by Liu Zhe on 7/15/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDActivityTableViewCell.h"


@interface CDActivityTableViewCell()

@end

@implementation CDActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    if (!self)
    {
        self = [super init];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
