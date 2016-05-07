//
//  HQQWaterFlowView.h
//  HQQWaterFlow
//
//  Created by 黄强强 on 16/5/6.
//  Copyright © 2016年 黄强强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQQWaterFlowView;
@class HQQWaterFlowViewCell;

typedef enum {
    HQQWaterFlowViewMarginTypeTop,          // 距离superView顶部的间距
    HQQWaterFlowViewMarginTypeBottom,       // 距离superView底部的间距
    HQQWaterFlowViewMarginTypeLeft,         // 距离superView左边的间距
    HQQWaterFlowViewMarginTypeRight,        // 距离superView右部的间距
    HQQWaterFlowViewMarginTypeRow,          // 内部每行cell的间距
    HQQWaterFlowViewMarginTypeColumn        // 内部每列cell的间距
} HQQWaterFlowViewMarginType;


@protocol HQQWaterFlowViewDataSource <NSObject>

/**
 *  告诉瀑布流一共有多少个item
 *
 *  @param waterFlowView 瀑布流对象
 *
 *  @return 行数
 */
- (NSInteger)numberOfItemsInWaterFlowView:(HQQWaterFlowView *)waterFlowView;

/**
 *  告诉瀑布流当前显示的View
 *
 *  @param waterFlowView 瀑布流对象
 *  @param indexPath     indexPath
 *
 *  @return 当前显示的HQQWaterFlowViewCell
 */
- (HQQWaterFlowViewCell *)waterFlowView:(HQQWaterFlowView *)waterFlowView cellForItemAtIndex:(NSInteger)index;

/**
 *  告诉瀑布流一共有多少列
 *
 *  @param waterFlowView 瀑布流对象
 *
 *  @return 列数
 */
- (NSInteger)numberOfColumnsInWaterFlowView:(HQQWaterFlowView *)waterFlowView;

@end


@protocol HQQWaterFlowViewDelegate <UIScrollViewDelegate>

/**
 *  返回第index个cell的高度
 */
- (CGFloat)waterFlowView:(HQQWaterFlowView *)waterFlowView heightForRowAtIndex:(NSInteger)index;

@optional

- (CGFloat)waterFlowView:(HQQWaterFlowView *)waterFlowView marginOfType:(HQQWaterFlowViewMarginType)marginType;

/**
 *  点击了哪个HQQWaterFlowViewCell
 *
 *  @param waterFlowView 瀑布流对象
 *  @param indexPath     indexPath
 */
- (void)waterFlowView:(HQQWaterFlowView *)waterFlowView didSelectItemAtIndex:(NSInteger)index;

@end


@interface HQQWaterFlowView : UIScrollView

+ (instancetype)waterFlowView;

/** 代理 */
@property (nonatomic, weak) id <HQQWaterFlowViewDelegate> delegate;

/** 数据源 */
@property (nonatomic, weak) id <HQQWaterFlowViewDataSource> dataSource;

/**
 *  从缓存池中根据标识符取出cell
 */
- (HQQWaterFlowViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

/**
 *  刷新数据
 */
- (void)reloadData;

/**
 *  根据序号获取对应的cell
 *
 *  @param index 点击了哪个item
 *
 *  @return 对应的cell
 */
- (HQQWaterFlowViewCell *)cellForItemAtIndex:(NSInteger)index;

@end
