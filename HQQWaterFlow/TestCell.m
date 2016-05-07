//
//  TestCell.m
//  HQQWaterFlow
//
//  Created by 黄强强 on 16/5/7.
//  Copyright © 2016年 黄强强. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.textLabel.text = dict[@"text"];
    self.imageView.image = [UIImage imageNamed:dict[@"icon"]];
}

@end
