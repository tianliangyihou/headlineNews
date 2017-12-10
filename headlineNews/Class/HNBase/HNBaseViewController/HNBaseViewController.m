//
//  HNBaseViewController.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/19.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNBaseViewController.h"

@interface HNBaseViewController ()

@end

@implementation HNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark 导航栏相关

- (UIBarButtonItem *)createItemWithImageName: (NSString *)imageName Selector:(SEL)selector{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake(0, 0, 21, 21);
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [imageView addGestureRecognizer:tap];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    return item;
}

- (UIBarButtonItem *)createItemWithText: (NSString *)text Selector:(SEL)selector{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:selector];
    return item;
}

- (void)addLeftItemWithImageName:(NSString *)imageName {
    self.navigationItem.leftBarButtonItem = [self createItemWithImageName:imageName Selector:@selector(leftItemAction)];
}
- (void)addRightItemWithImageName:(NSString *)imageName {
    self.navigationItem.rightBarButtonItem = [self createItemWithImageName:imageName Selector:@selector(rightItemAction)];
}

- (void)addLeftItemWithText:(NSString *)text {
    self.navigationItem.leftBarButtonItem = [self createItemWithText:text Selector:@selector(leftItemAction)];
}

- (void)addRightItemWithText:(NSString *)text {
    self.navigationItem.rightBarButtonItem = [self createItemWithText:text Selector:@selector(rightItemAction)];
}

- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemAction {
    
}
- (HNNavigationBar *)showCustomNavBar {
    HNNavigationBar *bar = [HNNavigationBar navigationBar];
    self.navigationItem.titleView = bar;
    return bar;
}



@end
