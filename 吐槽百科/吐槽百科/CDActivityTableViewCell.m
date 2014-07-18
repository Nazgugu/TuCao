//
//  CDActivityTableViewCell.m
//  PeerChina
//
//  Created by Liu Zhe on 7/15/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDActivityTableViewCell.h"
#import "FlatUIKit.h"

@interface CDActivityTableViewCell()
@property (weak, nonatomic) IBOutlet FUIButton *goButton;

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
    self.goButton.buttonColor = [UIColor turquoiseColor];
    self.goButton.shadowColor = [UIColor cloudsColor];
    self.goButton.highlightedColor = [UIColor greenSeaColor];
    self.goButton.shadowHeight = 1.0f;
    self.goButton.cornerRadius = 7.0f;
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
