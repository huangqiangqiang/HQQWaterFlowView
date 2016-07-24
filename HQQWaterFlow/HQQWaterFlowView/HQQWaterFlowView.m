//
//  HQQWaterFlowView.m
//  HQQWaterFlow
//
//  Created by 黄强强 on 16/5/6.
//  Copyright © 2016年 黄强强. All rights reserved.
//

#import "HQQWaterFlowView.h"
#import "HQQWaterFlowViewCell.h"

@interface HQQWaterFlowView ()
/**
 *  有多少列
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 *  目前正在展示的cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
/**
 *  在缓存池中的cell
 */
@property (nonatomic, strong) NSMutableSet *reuseCells;
@end

@implementation HQQWaterFlowView

#pragma mark - 懒加载
- (NSMutableArray *)cellFrames
{
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells
{
    if (!_displayingCells) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSMutableSet *)reuseCells
{
    if (!_reuseCells) {
        _reuseCells = [NSMutableSet set];
    }
    return _reuseCells;
}

+ (instancetype)waterFlowView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) return ;
    [self reloadData];
}

- (void)reloadData
{
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.displayingCells removeAllObjects];
    [self.reuseCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    
    NSInteger numberOfCells = [self.dataSource numberOfItemsInWaterFlowView:self];
    
    CGFloat marginOfTop = [self.delegate waterFlowView:self marginOfType:HQQWaterFlowViewMarginTypeTop];
    CGFloat marginOfLeft = [self.delegate waterFlowView:self marginOfType:HQQWaterFlowViewMarginTypeLeft];
    CGFloat marginOfBottom = [self.delegate waterFlowView:self marginOfType:HQQWaterFlowViewMarginTypeBottom];
    CGFloat marginOfRow = [self.delegate waterFlowView:self marginOfType:HQQWaterFlowViewMarginTypeRow];
    CGFloat marginOfColumn = [self.delegate waterFlowView:self marginOfType:HQQWaterFlowViewMarginTypeColumn];
    NSInteger numberOfColumns = [self.dataSource numberOfColumnsInWaterFlowView:self];
    
    CGFloat cellW = [self cellWidth];
    
    // 定义一个C语言的数组，存储每一列最大Y值
    CGFloat maxYcolumn[numberOfColumns];
    for (int i = 0; i < numberOfColumns; i++) {
        maxYcolumn[i] = 0.0;
    }
    
    for (int i = 0; i < numberOfCells; i++) {
        
        CGFloat w = cellW;
        CGFloat h = [self.delegate waterFlowView:self heightForRowAtIndex:i];
        
        // 1. 哪一列高度最小
        CGFloat minY = maxYcolumn[0];
        NSInteger col = 0;
        for (int j = 1; j < numberOfColumns; j++) {
            if (maxYcolumn[j] < minY) {
                minY = maxYcolumn[j];
                col = j;
            }
        }
        
        // 2. 计算frame
        CGFloat x = col * (cellW + marginOfRow) + marginOfLeft;
        CGFloat y = 0;
        if (minY == 0) {
            y = marginOfTop;
        }else{
            y = minY + marginOfColumn;
        }
        
        CGRect rect = CGRectMake(x, y, w, h);
        
        // 更新第col列的高度
        maxYcolumn[col] = CGRectGetMaxY(rect);
        
        // 把所有cell的frame保存起来
        [self.cellFrames addObject:[NSValue valueWithCGRect:rect]];
        
        // 设置contentSize
        if (i == numberOfCells - 1) {
            CGFloat maxY = 0.0;
            for (int j = 0; j < numberOfColumns; j++) {
                if (maxYcolumn[j] > maxY) {
                    maxY = maxYcolumn[j];
                }
            }
            self.contentSize = CGSizeMake(self.frame.size.width, maxY + marginOfBottom);
        }
    }
    NSLog(@"cellFrames : %@",self.cellFrames);
}

- (CGFloat)cellWidth
{
    // 行间距
    CGFloat marginOfRow = [self.delegate waterFlowView:self marginOfType:HQQWaterFlowViewMarginTypeRow];
    CGFloat marginOfLeft = [self.delegate waterFlowView:self marginOfType:HQQWaterFlowViewMarginTypeLeft];
    CGFloat marginOfRight = [self.delegate waterFlowView:self marginOfType:HQQWaterFlowViewMarginTypeRight];
    // 多少列
    NSInteger numberOfColumns = [self.dataSource numberOfColumnsInWaterFlowView:self];
    
    return (self.frame.size.width - marginOfRow * (numberOfColumns - 1) - marginOfLeft - marginOfRight) / numberOfColumns;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.cellFrames.count;
    
    for (int i = 0; i < count; i++) {
        CGRect rect = [self.cellFrames[i] CGRectValue];
        
        if ([self isInScreen:rect]) {
            // 应该显示在屏幕上
            HQQWaterFlowViewCell *cell = self.displayingCells[@(i)];
            if (!cell) {
                cell = [self.dataSource waterFlowView:self cellForItemAtIndex:i];
                cell.frame = rect;
                [self addSubview:cell];
                
                self.displayingCells[@(i)] = cell;
            }
            
        }else{
            // 在屏幕外
            HQQWaterFlowViewCell *cell = self.displayingCells[@(i)];
            if (cell) {
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                
                // 加入到缓存池
                [self.reuseCells addObject:cell];
            }
        }
        
    }
    
//    NSLog(@"reuseCells : %@",self.reuseCells);
}

/**
 *  是否显示在屏幕上
 *
 *  @param rect cell的frame
 *
 *  @return YES：显示在屏幕上，NO：在屏幕外
 */
- (BOOL)isInScreen:(CGRect)rect
{
    CGRect screenRect = CGRectMake(0, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
    if (CGRectContainsPoint(screenRect, CGPointMake(rect.origin.x, rect.origin.y)) || CGRectContainsPoint(screenRect, CGPointMake(rect.origin.x, CGRectGetMaxY(rect)))) {
        return YES;
    }else{
        return NO;
    }
}

- (void)clickedCell:(UITapGestureRecognizer *)tap
{
    NSLog(@"tap");
}

- (HQQWaterFlowViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (self.reuseCells.count > 0) {
        __block HQQWaterFlowViewCell *cell = nil;
        [self.reuseCells enumerateObjectsUsingBlock:^(HQQWaterFlowViewCell *obj, BOOL * _Nonnull stop) {
            if ([obj.reuseIdentifier isEqualToString:identifier]) {
                cell = obj;
            }
        }];
        
        // 从缓存池中移除
        if (cell) {
            [self.reuseCells removeObject:cell];
        }
        return cell;
    }
    return nil;
}

- (HQQWaterFlowViewCell *)cellForItemAtIndex:(NSInteger)index
{
    HQQWaterFlowViewCell *cell = self.displayingCells[@(index)];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (int i = 0; i < self.cellFrames.count; i++) {
        CGRect rect = [self.cellFrames[i] CGRectValue];
        if (CGRectContainsPoint(rect, point)) {
            if ([self.delegate respondsToSelector:@selector(waterFlowView:didSelectItemAtIndex:)]) {
                [self.delegate waterFlowView:self didSelectItemAtIndex:i];
            }
        }
    }
}

@end
