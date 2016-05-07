//
//  HQQWaterFlowViewCell.h
//  HQQWaterFlow
//
//  Created by 黄强强 on 16/5/6.
//  Copyright © 2016年 黄强强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQQWaterFlowViewCell : UIView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/** 重用标识符 */
@property (nonatomic, copy) NSString *reuseIdentifier;

@property (nonatomic, weak) UILabel *textLabel;

@property (nonatomic, weak) UIImageView *imageView;

@end
