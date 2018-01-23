# headlineNews

 如果您觉得不错，记得给一个star😜
 
 采用了MVVM + RAC的方式,对微头条界面 使用`YYCache` 进行了本地缓存
 
效果跟目前最新的今日头条有些地方不一样,因为今日头条最近更新了新版本
```
  下面对项目中的一些效果和实现思路做下介绍

  如果您有什么问题或者建议,欢迎在简书下面留言或者在github上issue me
```
#### 网络请求
以首页的顶部的菜单栏为例

![WX20180123.png](http://upload-images.jianshu.io/upload_images/2306467-183b92337ab238ee.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

开始网络请求

```
- (void)viewDidLoad {
    [super viewDidLoad];
    HNNavigationBar *bar = [self showCustomNavBar];
    [bar.searchSubjuct subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self configUI];
    @weakify(self)
    [[self.titleViewModel.titlesCommand execute:@13] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.models = x;
        [self reloadData];
        [self configPageVC];
    }];
    
}
```
HNHomeTitleViewModel 中网络请求的处理 

这里对网络请求的处理,相对于正常对AFNetWorking的封装,又进行了进一步的封装.

可以参考链接 https://www.jianshu.com/p/1f5cd52981a1
 ```
 _titlesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HNHomeTitleRequest *request = [HNHomeTitleRequest netWorkModelWithURLString:HNURLManager.homeTitleURLString isPost:NO];
                request.iid = HN_IID;
                request.device_id = HN_DEVICE_ID;
                request.aid = [input intValue];
                [request sendRequestWithSuccess:^(id response) {
                    NSDictionary *responseDic = (NSDictionary *)response;
                    responseDic = responseDic[@"data"];
                    NSMutableArray *models = [NSMutableArray array];
                    if (responseDic.count > 0) {
                        NSArray *dicArr = responseDic[@"data"];
                        for (int i = 0; i < [dicArr count]; i++) {
                            HNHomeTitleModel *model = [[HNHomeTitleModel new] mj_setKeyValues:dicArr[i]];
                            [models addObject:model];
                        }
                        [subscriber sendNext:models];
                        [subscriber sendCompleted];
                    }else {
                        [MBProgressHUD showError: HN_ERROR_SERVER toView:nil];
                    }
                } failure:^(NSError *error) {
                    // do something
                }];
                return nil;
            }];
        }];
```

#### 首页图片的展示

![WX20180123.png](http://upload-images.jianshu.io/upload_images/2306467-ac2fb284ea537d07.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objc
 这个界面上展示的图片都是webp格式的. SDWebImage需要下载一个依赖库才能支持
SDWebImage 文档上关于如何加载webp格式图片的介绍很简单 : 
 pod 'SDWebImage/WebP'
 
但是当你实际操作起来,这个东西是一直下载不下来的,即使你开了vpn
你可以看下这个连接的内容: https://www.jianshu.com/p/4468f03cf606
如果还是下载不下来,就还需要调整一些东西,可以在issue me
```
#### 编辑频道界面

![effect2.gif](https://upload-images.jianshu.io/upload_images/2306467-807ef4acf2aef144.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/339)

编辑频道界面主要是frame的计算,这个是一个消耗cpu的行为,可以在异步线程完成

故把消耗性能的frame计算等 都放在了后台线程,等后台线程计算完毕 在主线程更新UI

创建一个同步队列,用来专门处理frame相关的计算

 _queue = dispatch_queue_create("com.headlineNews.queue", DISPATCH_QUEUE_SERIAL);
 
比如 长按后 交换两个按钮的位置
```objc
#pragma mark - 交换两个按钮的位置
- (void)adjustCenterForBtn:(HNButton *)btn withGes:(UILongPressGestureRecognizer *)ges{
    CGPoint newPoint = [ges locationInView:self];
    btn.center = newPoint;
    __weak typeof(self) wself = self;
    [self newLocationTagForBtn:btn locationBlock:^(HNChannelModel* targetModel) {
        if (wself.divisionModel == btn.model) {
            HNChannelModel *divisionModel = self.datas[btn.model.tag - 1];
            _divisionModel = divisionModel;
        }else if (wself.divisionModel == targetModel){
            _divisionModel = btn.model;
            
        }
        [wself.datas removeObject:btn.model];
        [wself.datas insertObject:btn.model atIndex:targetModel.tag];
        for (int i = 0 ; i < wself.datas.count; i++) {
            HNChannelModel *model = wself.datas[i];
            model.tag = i;
            if (model.isMyChannel && model != btn.model) {
                model.frame = MYCHANNEL_FRAME(i);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0 ; i < wself.datas.count; i++) {
                HNChannelModel *model = wself.datas[i];
                if (model.isMyChannel && model != btn.model) {
                    [UIView animateWithDuration:0.25 animations:^{
                        model.btn.frame = model.frame;
                    }];
                }
            }

        });
    }];
}
- (void)newLocationTagForBtn:(HNButton *)moveBtn locationBlock:(void(^)(HNChannelModel* targetModel))locationBlock {
    HNChannelModel *moveBtnModel = moveBtn.model;
    CGPoint moveBtnCenter = moveBtn.center;
    dispatch_async(_queue, ^{
        NSMutableArray *models = [[NSMutableArray alloc]initWithArray:self.datas];
        for (HNChannelModel *model in models) {
            if (model == moveBtnModel) {
                continue;
            }
            if (!model.isMyChannel) {
                continue;
            }
            if (CGRectContainsPoint(model.frame,moveBtnCenter)) {
                locationBlock(model);
            }
        }
    });
}

```

#### 首页tabber图标的切换和动画效果

![effect3.gif](http://upload-images.jianshu.io/upload_images/2306467-175ad11813726ffe.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objc
- (void)addAnnimation {
    // 这里使用了 私有API 但是审核仍可以通过 有现成的案例
    UIControl *tabBarButton = [_homeNav.tabBarItem valueForKey:@"view"];
    UIImageView *tabBarSwappableImageView = [tabBarButton valueForKey:@"info"];
    [tabBarSwappableImageView rotationAnimation];
    _swappableImageView = tabBarSwappableImageView;
    [self.tabBar hideBadgeOnItemIndex:0];
}
```

#### 首页顶部菜单栏的效果

![effect4.gif](http://upload-images.jianshu.io/upload_images/2306467-4bdc9f71827778f6.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objc
这里采用了WMPageController,但是并不能完全满足需求,对其源码做了一些修改

1 边角的+号按钮的半透明效果

2  当某个菜单栏处于选中状态下,再次点击的刷新效果
```
详情可下载项目查看

#### 视频的播放

![effect5.gif](http://upload-images.jianshu.io/upload_images/2306467-8463eb3f5346fa0c.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objc
这里采用了ZFPlayer,github上一个有4000star的开源库
```
ZFPlayer github地址 https://github.com/renzifeng/ZFPlayer

#### 微头条的实现顶部的隐藏效果

![effect6.gif](http://upload-images.jianshu.io/upload_images/2306467-d29efa11e845006b.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objc
 这里采用了rac 监控tableView的滑动
CGFloat tableViewHeight = HN_SCREEN_HEIGHT - HN_NAVIGATION_BAR_HEIGHT - HN_TABBER_BAR_HEIGHT - 40;
    @weakify(self);
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        CGPoint contentOffset = [x CGPointValue];
        if (contentOffset.y > 0) {
            optionView.top = contentOffset.y <= 40 ? -contentOffset.y : -40;
            self.tableView.top = floorf(contentOffset.y <= 40 ? 40 - contentOffset.y : 0);
            self.tableView.height = floorf(contentOffset.y <= 40 ? tableViewHeight + contentOffset.y : tableViewHeight + 40);
        }else {
            optionView.top = 0;
            self.tableView.top = 40;
            self.tableView.height = tableViewHeight;
        }
    }];
```
#### 微头条的图片浏览效果

![effect7.gif](https://upload-images.jianshu.io/upload_images/2306467-d8e9c32b090bc6a1.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/338)

```objc
这里采用了LBPhotoBrowser,这个是本人开发的一个图片浏览器.

1 支持gif图片播放(2种方式)
2 对图片进行预加载
```
关于LBPhotoBrowser可查看: https://github.com/tianliangyihou/LBPhotoBrowser

#### 微头条的文字的内容中  `@` `# ` `链接` 内容的识别, 以及文字过长添加`全文`按钮

![effect8.gif](http://upload-images.jianshu.io/upload_images/2306467-c79ea97ff466519b.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objc
  这里采用了正则匹配与YYText结合的方式,例如对于 #话题# 
  
  // #话题#的规则
    NSError *topicError;
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    NSRegularExpression *topicRegex = [NSRegularExpression regularExpressionWithPattern:topicPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&topicError];
    NSArray *topicMatches = [topicRegex matchesInString:_hn_content.string options:0 range:NSMakeRange(0, [_hn_content.string length])];

    for (NSTextCheckingResult *match in topicMatches)
    {
        if (match.range.location == NSNotFound ) continue;
        [_hn_content yy_setColor:hn_cell_link_nomalColor range:match.range];
        // 高亮状态
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        [highlight setColor:hn_cell_link_hightlightColor];
        // 数据信息，用于稍后用户点击
        highlight.userInfo = @{hn_topic : [_hn_content.string substringWithRange:NSMakeRange(match.range.location + 1, match.range.length - 1)]};
        [_hn_content yy_setTextHighlight:highlight range:match.range];

    }
```
#### 保证微头条界面流畅性

```objc
当网络请求结束后,解析数据为多个model
cell的上内容怎么显示,都应该是由model决定的,对应每个cell创建一个HNMicroLayout, 在后台线程中完成   #xxxx # @ 链接的匹配
以及各个控件在cell中的布局信息.计算完成后 在主线程更新UI.

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        [[HNDiskCacheHelper defaultHelper] setMaxArrayCount:9 forKey:cacheKey];
        _microHeadlineCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               @strongify(self)
                [self requestWithSubscriber:subscriber input:input];
                return nil;
            }];
        }];
    }
    return self;
}

- (void)requestWithSubscriber:(id<RACSubscriber>)subscriber input:(id)input{
    HNMicroHeadlineRequest *request = [HNMicroHeadlineRequest netWorkModelWithURLString:HNURLManager.microHeadlineURLString isPost:NO];
    request.iid = HN_IID;
    request.device_id = HN_DEVICE_ID;
    request.count = @15;
    request.category = @"weitoutiao";
    @weakify(self);
    [request sendRequestWithSuccess:^(id response) {
        @strongify(self);
        // --> 复杂的模型处理应该放在异步
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            HNMicroHeadlineModel *model = [[HNMicroHeadlineModel alloc]init];
            [model mj_setKeyValues:response];
            [model.data makeObjectsPerformSelector:@selector(detialModel)];
            NSMutableArray *layouts = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HNMicroHeadlineSummaryModel *model = (HNMicroHeadlineSummaryModel *)obj;
                HNMicroLayout *layout = [[HNMicroLayout alloc]initWithMicroHeadlineModel:model];
                [layouts addObject:layout];
            }];
            HN_ASYN_GET_MAIN(
                             if ([model.message isEqualToString:@"success"]) {
                                 [self setCacheLayouts:layouts withRefresh:input];
                                 [subscriber sendNext:layouts];
                                 [subscriber sendCompleted];
                             }else {
                                 [MBProgressHUD showError:HN_ERROR_SERVER toView:nil];
                             }
                             );
        });
    } failure:^(NSError *error) {
        // do something
        [subscriber sendError:error];
    }];
}
```
YYKit 作者写的关于界面流畅性的技巧:
https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/

#### 微头条的点赞动画

![effect9.gif](http://upload-images.jianshu.io/upload_images/2306467-4d08f50b0eda82c9.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objc
采用了粒子动画

- (void)setUp {
    for (int i = 0; i < sendCountEveryTime; i++) {
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.name           = [NSString stringWithFormat:@"explosion_%d",i];
        cell.alphaRange     = 0.5;
        cell.alphaSpeed     = -0.5;
        cell.lifetime       = 4;
        cell.lifetimeRange  = 2;
        cell.velocity       = 600;
        cell.velocityRange  = 200.00;
        cell.scale          = 0.5;
        cell.yAcceleration = 600;
        cell.emissionLongitude = 2 *M_PI - M_PI /4.0;
        cell.emissionRange = M_PI / 2.0;
        [self.cells addObject:cell];
    }
}
 - (void)showEmitterCellsWithImages:(NSArray<UIImage *>*)images withShock:(BOOL)shouldShock onView:(UIView *)view{
    for (int i = 0; i< images.count; i++) {
        CAEmitterCell *cell = self.cells[i];
        cell.contents = (__bridge id _Nullable)(images[i].CGImage);
    }
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.name = @"emitterLayer";
    layer.position = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
    layer.emitterCells = self.cells;
    [view.layer addSublayer:layer];
    [self explodeWithView:view andLayer:layer];

}
```

#### 全屏pop 动画

![effect10.gif](http://upload-images.jianshu.io/upload_images/2306467-40e167e6019be940.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```objc
- (void)addCustomGesPop {
    
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    _pan = pan;
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    
    self.interactivePopGestureRecognizer.enabled = NO;
}
以及在特定界面关掉这个效果
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HNNavigationController *nav = (HNNavigationController *)self.navigationController;
    [nav stopPopGestureRecognizer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    HNNavigationController *nav = (HNNavigationController *)self.navigationController;
    [nav startPopGestureRecognizer];
}

```
完整效果图

![effect_hn.gif](https://github.com/tianliangyihou/zhuxian/blob/master/effect_hn.gif?raw=true)


