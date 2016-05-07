//
//  ViewController.m
//  HQQWaterFlow
//
//  Created by 黄强强 on 16/5/6.
//  Copyright © 2016年 黄强强. All rights reserved.
//

#import "ViewController.h"
#import "HQQWaterFlowView.h"
#import "HQQWaterFlowViewCell.h"

@interface ViewController () <HQQWaterFlowViewDataSource, HQQWaterFlowViewDelegate, UITableViewDelegate, UITableViewDataSource>
/** 瀑布流对象 */
@property (nonatomic, weak) HQQWaterFlowView *waterFlowView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    HQQWaterFlowView *waterFlowView = [HQQWaterFlowView waterFlowView];
    waterFlowView.dataSource = self;
    waterFlowView.delegate = self;
    waterFlowView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:waterFlowView];
    self.waterFlowView = waterFlowView;
}

- (NSInteger)numberOfColumnsInWaterFlowView:(HQQWaterFlowView *)waterFlowView
{
    return 3;
}

- (NSInteger)numberOfItemsInWaterFlowView:(HQQWaterFlowView *)waterFlowView
{
    return 60;
}

- (HQQWaterFlowViewCell *)waterFlowView:(HQQWaterFlowView *)waterFlowView cellForItemAtIndex:(NSInteger)index
{
    static NSString *reuseid = @"HQQWaterFlowViewCell";
    HQQWaterFlowViewCell *cell = [waterFlowView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[HQQWaterFlowViewCell alloc] initWithReuseIdentifier:reuseid];
        cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",index];
    return cell;
}

- (CGFloat)waterFlowView:(HQQWaterFlowView *)waterFlowView marginOfType:(HQQWaterFlowViewMarginType)marginType
{
    if (marginType == HQQWaterFlowViewMarginTypeTop) {
        return 20.0;
    }else if (marginType == HQQWaterFlowViewMarginTypeBottom) {
        return 20.0;
    }
    return 10.0;
}

- (void)waterFlowView:(HQQWaterFlowView *)waterFlowView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"didSelectItemAtIndexPath - %zd",index);
}

- (CGFloat)waterFlowView:(HQQWaterFlowView *)waterFlowView heightForRowAtIndex:(NSInteger)index
{
    return arc4random_uniform(100) + 150;
}

@end
