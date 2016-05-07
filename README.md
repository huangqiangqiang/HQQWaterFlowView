# HQQWaterFlowView
瀑布流布局控件
实现分三步
* 1. 添加瀑布流控件
* 2. 添加协议
* 3. 实现数据源代理方法

```objc
// 1. 添加瀑布流控件
HQQWaterFlowView *waterFlowView = [HQQWaterFlowView waterFlowView];
waterFlowView.dataSource = self;
waterFlowView.delegate = self;
waterFlowView.frame = [UIScreen mainScreen].bounds;
[self.view addSubview:waterFlowView];

// 2. 添加协议
@interface ViewController () <HQQWaterFlowViewDataSource, HQQWaterFlowViewDelegate>

// 3. 实现数据源代理方法
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
    HQQWaterFlowViewCell *cell = (HQQWaterFlowViewCell *)[waterFlowView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[HQQWaterFlowViewCell alloc] initWithReuseIdentifier:reuseid];
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
```
