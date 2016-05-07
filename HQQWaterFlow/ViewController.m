//
//  ViewController.m
//  HQQWaterFlow
//
//  Created by 黄强强 on 16/5/6.
//  Copyright © 2016年 黄强强. All rights reserved.
//

#import "ViewController.h"
#import "HQQWaterFlowView.h"
#import "TestCell.h"

@interface ViewController () <HQQWaterFlowViewDataSource, HQQWaterFlowViewDelegate>
/** 瀑布流对象 */
@property (nonatomic, weak) HQQWaterFlowView *waterFlowView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation ViewController

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"text"] = [NSString stringWithFormat:@"test - %zd",i];
            dict[@"icon"] = @"placeholder.jpg";
            [_dataList addObject:dict];
        }
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加瀑布流控件
    HQQWaterFlowView *waterFlowView = [HQQWaterFlowView waterFlowView];
    waterFlowView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    waterFlowView.dataSource = self;
    waterFlowView.delegate = self;
    waterFlowView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:waterFlowView];
    self.waterFlowView = waterFlowView;
    
    // 添加刷新控件
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(start) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self.waterFlowView addSubview:refresh];
}

- (void)start
{
    NSLog(@"start");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNewData];
        [self.refreshControl endRefreshing];
    });
}

- (NSInteger)numberOfColumnsInWaterFlowView:(HQQWaterFlowView *)waterFlowView
{
    return 3;
}

- (NSInteger)numberOfItemsInWaterFlowView:(HQQWaterFlowView *)waterFlowView
{
    return self.dataList.count;
}

- (HQQWaterFlowViewCell *)waterFlowView:(HQQWaterFlowView *)waterFlowView cellForItemAtIndex:(NSInteger)index
{
    static NSString *reuseid = @"HQQWaterFlowViewCell";
    TestCell *cell = (TestCell *)[waterFlowView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[TestCell alloc] initWithReuseIdentifier:reuseid];
    }
    
    cell.dict = self.dataList[index];
    
    if (index == [self numberOfItemsInWaterFlowView:waterFlowView] - [self numberOfColumnsInWaterFlowView:waterFlowView]) {
        // 请求更多数据
        [self loadMoreData];
    }
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

- (void)loadNewData
{
    [self.dataList removeAllObjects];
    
    NSInteger count = self.dataList.count;
    for (NSInteger i = count; i < count + 20; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"text"] = [NSString stringWithFormat:@"test - %zd",i];
        dict[@"icon"] = @"placeholder.jpg";
        [self.dataList addObject:dict];
    }
    
    [self.waterFlowView reloadData];
}

- (void)loadMoreData
{
    NSInteger count = self.dataList.count;
    
    for (NSInteger i = count; i < count + 20; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"text"] = [NSString stringWithFormat:@"test - %zd",i];
        dict[@"icon"] = @"placeholder.jpg";
        [self.dataList addObject:dict];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.waterFlowView reloadData];
    });
}

@end
