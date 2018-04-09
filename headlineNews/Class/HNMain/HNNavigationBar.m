//
//  HNNavigationBar.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/21.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNNavigationBar.h"
#import "HNHeader.h"

@interface HNSearchBar: UITextField

@end

@interface HNActionImageView: UIImageView

@property (nonatomic , copy)void(^imageClickBlock)(void);

@end


@interface HNNavigationBar ()<UITextFieldDelegate>

@end

@implementation HNNavigationBar

+ (instancetype)navigationBar {
    HNNavigationBar *bar = [[HNNavigationBar alloc]initWithFrame:CGRectMake(0, 0, HN_SCREEN_WIDTH, HN_NAVIGATION_BAR_HEIGHT)];
    bar.backgroundColor = [UIColor colorWithRed:0.83 green:0.24 blue:0.24 alpha:1];
    return bar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        HNActionImageView *mineImageView = [[HNActionImageView alloc]init];
        mineImageView.image = [UIImage imageNamed:@"home_no_login_head"];
        [self addSubview:mineImageView];
        @weakify(self);
        [mineImageView setImageClickBlock:^{
            @strongify(self);
            if (self.navigationBarCallBack) {
                self.navigationBarCallBack(HNNavigationBarActionMine);
            }
        }];
        
        HNActionImageView *cameraImageView =  [[HNActionImageView alloc]init];
        cameraImageView.image = [UIImage imageNamed:@"home_camera"];
        [self addSubview:cameraImageView];
        [cameraImageView setImageClickBlock:^{
            @strongify(self);
            if (self.navigationBarCallBack) {
                self.navigationBarCallBack(HNNavigationBarActionSend);
            }
        }];
        
        
        HNSearchBar *searchBar = [[HNSearchBar alloc]init];
        searchBar.borderStyle = UITextBorderStyleRoundedRect;
        searchBar.backgroundColor = [UIColor whiteColor];
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        leftView.image = [UIImage imageNamed:@"searchicon_search_20x20_"];
        searchBar.leftView = leftView;
        searchBar.delegate = self;
        searchBar.text = @"搜你想搜的";
        searchBar.textColor = [UIColor grayColor];
        searchBar.font = [UIFont systemFontOfSize:12];
        searchBar.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:searchBar];
        
        
        [mineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(self).offset(-9);
            make.left.mas_equalTo(self).offset(15);
        }];
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(mineImageView.mas_right).offset(15);
            make.right.mas_equalTo(cameraImageView.mas_left).offset(-15);
            make.bottom.mas_equalTo(self).offset(-9);
            make.height.mas_equalTo(26);
        }];
        
        [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.right.mas_equalTo(self).offset(-15);
            make.bottom.mas_equalTo(self).offset(-9);

        }];
        _searchSubjuct = [RACSubject subject];
    }
    return self;
}


#pragma mark - 代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_searchSubjuct sendNext: textField];
    return NO;
}
// 重写适配11
- (CGSize)intrinsicContentSize {
    return CGSizeMake(HN_SCREEN_WIDTH - 24, 44.f);
}
@end

@implementation HNSearchBar
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 8;
    return iconRect;
}
@end

@implementation HNActionImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.imageClickBlock) {
        self.imageClickBlock();
    }
}
@end
