//
//  HQQWaterFlowViewCell.m
//  HQQWaterFlow
//
//  Created by 黄强强 on 16/5/6.
//  Copyright © 2016年 黄强强. All rights reserved.
//

#import "HQQWaterFlowViewCell.h"

@implementation HQQWaterFlowViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.reuseIdentifier = reuseIdentifier;
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        self.textLabel = label;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20);
    self.textLabel.frame = CGRectMake(0, self.imageView.frame.size.height, self.frame.size.width, 20);
}

@end
