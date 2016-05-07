# HQQWaterFlowView
瀑布流布局控件

```objc
// 添加瀑布流控件
HQQWaterFlowView *waterFlowView = [HQQWaterFlowView waterFlowView];
waterFlowView.dataSource = self;
waterFlowView.delegate = self;
waterFlowView.frame = [UIScreen mainScreen].bounds;
[self.view addSubview:waterFlowView];
```
