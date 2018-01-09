//
//  HNMicroLayout.h
//  headlineNews
//
//  Created by dengweihao on 2017/12/8.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNMicroHeadlineModel.h"
#import <YYText/YYText.h>
#import <YYText/NSAttributedString+YYText.h>
#define hn_cell_Left_margin 10
#define hn_cell_right_margin 10
#define hn_cell_top_margin 20
#define hn_cell_bottom_margin 10
#define hn_cell_pic_margin 5

#define hn_cell_name_Label_Font [UIFont systemFontOfSize:14]
#define hn_cell_follow_btn_Font [UIFont systemFontOfSize:14]
#define hn_cell_subTitle_Label_Font [UIFont systemFontOfSize:12]
#define hn_cell_content_Label_Font [UIFont systemFontOfSize:15] // 字体调成20的问题
#define hn_cell_read_Label_Font [UIFont systemFontOfSize:12]

#define  hn_cell_link_nomalColor  [UIColor blueColor]
#define  hn_cell_link_hightlightColor [UIColor yellowColor]

#define hn_AT @"at"
#define hn_link @"link"
#define hn_emoticon @"emoticon"
#define hn_topic @"topic"
#define hn_allArticle @"article"

#define hn_cell_content_label_max_lines 5

@interface HNMicroLayout : NSObject <NSCoding>

@property (nonatomic , strong)HNMicroHeadlineSummaryModel *model;

@property (nonatomic , assign)CGFloat height;

@property (nonatomic , copy)NSString *readCountStr;

@property (nonatomic , strong)NSArray *picFrameArrays;

@property (nonatomic , copy)NSMutableAttributedString *hn_content;

@property (nonatomic , strong)NSData *hn_content_data;


@property (nonatomic , assign)CGFloat contentHeight;

- (instancetype)initWithMicroHeadlineModel:(HNMicroHeadlineSummaryModel *)model;

@end
