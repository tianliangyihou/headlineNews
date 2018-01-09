//
//  HNMicroLayout.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/8.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMicroLayout.h"
#import "HNEmoticonHelper.h"
#import <MJExtension/MJExtension.h>

static inline NSRegularExpression * regexAt() {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

static inline NSRegularExpression * regexEmoticon() {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

static inline CGFloat containerWith(){
    return [UIScreen mainScreen].bounds.size.width - hn_cell_Left_margin - hn_cell_right_margin;
}
@interface HNMicroLayout ()


@end

@implementation HNMicroLayout

- (instancetype)initWithMicroHeadlineModel:(HNMicroHeadlineSummaryModel *)model {
    if (self = [super init]) {
        _model = model;
        _height = 0;
        _contentHeight = 0;
        [self hn_layout];
    }
    return self;
}
// 简化版的分析
- (void)hn_layout {
    [self hn_titleLayout];
    [self hn_contentLayout];
    [self hn_picsLayout];
    [self hn_readMsgLayout];
    [self hn_actionLayout];
}
// 头像..
- (void)hn_titleLayout {
    _height = _height + hn_cell_top_margin + 40;
}
// 内容
- (void)hn_contentLayout {
    
    if (_model.detialModel.user.desc.length == 0) {
        return;
    }
    _hn_content = [[NSMutableAttributedString alloc]initWithString:_model.detialModel.content];
    _hn_content.yy_font = hn_cell_content_Label_Font;

    // 设置高亮的范围
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor redColor];
    
    // 处理@的情况
    NSArray *atResults = [regexAt() matchesInString:_hn_content.string options:kNilOptions range:_hn_content.yy_rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound ) continue;
        [_hn_content yy_setColor:hn_cell_link_nomalColor range:at.range];
        // 高亮状态
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        [highlight setColor:hn_cell_link_hightlightColor];
        
        // 数据信息，用于稍后用户点击
        highlight.userInfo = @{hn_AT : [_hn_content.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
        [_hn_content yy_setTextHighlight:highlight range:at.range];
    }
    
    // 处理表情 [大哭] [耶]
    NSArray<NSTextCheckingResult *> *emoticonResults = [regexEmoticon() matchesInString:_hn_content.string options:kNilOptions range:_hn_content.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        NSString *emoString = [_hn_content.string substringWithRange:range];
        UIImage *image = [HNEmoticonHelper emoticonMapper][emoString];
        if (!image) continue;
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:14];
        [_hn_content replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    // 处理链接
    NSError *linkError;
    NSString *linkRegulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *linkRegex = [NSRegularExpression regularExpressionWithPattern:linkRegulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&linkError];
    NSArray *linkMatches = [linkRegex matchesInString:_hn_content.string options:0 range:NSMakeRange(0, [_hn_content.string length])];
    
    for (NSTextCheckingResult *match in linkMatches)
    {
        if (match.range.location == NSNotFound ) continue;
        [_hn_content yy_setColor:hn_cell_link_nomalColor range:match.range];
        // 高亮状态
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        [highlight setColor:hn_cell_link_hightlightColor];
        // 数据信息，用于稍后用户点击
        highlight.userInfo = @{hn_link : [_hn_content.string substringWithRange:match.range]};
        [_hn_content yy_setTextHighlight:highlight range:match.range];
    }
    
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
    
    // 给过长的文字添加...全文
    _hn_content.yy_lineSpacing = 0;
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 24;
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(containerWith(), 1000);
    container.linePositionModifier = modifier;
    YYTextLayout *layout =  [YYTextLayout layoutWithContainer:container text:_hn_content];
    if (layout.lines.count > hn_cell_content_label_max_lines) {
        _contentHeight += hn_cell_content_label_max_lines * 24;
    }else {
        if (layout.lines && layout.lines.count > 0)
            _contentHeight += layout.lines.count * 24;
    }
    _height = _height + _contentHeight;
    _hn_content_data = _hn_content.yy_archiveToData;
}
// 图片
- (void)hn_picsLayout {
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    if (_model.detialModel.thumb_image_list.count > 0) {
        _height += 5;
        switch (_model.detialModel.thumb_image_list.count) {
            case 1:
            {
                CGRect frame = CGRectMake(0, 0, 200, 150);
                [frames addObject: [NSValue valueWithCGRect:frame]];
                _height = _height + 150;
            }
                break;
            case 2:
            {
                CGFloat width = (containerWith() - hn_cell_pic_margin)/2.0;
                CGRect frameLeft = CGRectMake(0, 0, width, width);
                CGRect frameRight = CGRectMake(CGRectGetMaxX(frameLeft) + hn_cell_pic_margin, 0, width, width);
                [frames addObject: [NSValue valueWithCGRect:frameLeft]];
                [frames addObject: [NSValue valueWithCGRect:frameRight]];
                _height = _height + width;
            }
                break;
                
            default:
            {
                int column = _model.detialModel.thumb_image_list.count == 4 ? 2 : 3;
                CGFloat itemWidth = (containerWith() - 2 * hn_cell_pic_margin) / 3;
                CGFloat itemHeight = itemWidth;
                CGFloat maxHeight = 0;
                for (int i = 0; i < _model.detialModel.thumb_image_list.count; i++) {
                    CGFloat x = (i % column) * (hn_cell_pic_margin + itemWidth) ;
                    CGFloat y = (i / column) * (hn_cell_pic_margin + itemHeight);
                    CGRect frame = CGRectMake(x, y, itemWidth, itemHeight);
                    maxHeight = CGRectGetMaxY(frame);
                    [frames addObject:[NSValue valueWithCGRect:frame]];
                }
                _height = _height + maxHeight;
            }
                break;
        }
        _picFrameArrays = frames;
    }
    
}
// 阅读数
- (void)hn_readMsgLayout {
    if (_model.detialModel.read_count > 10000) {
        self.readCountStr = [NSString stringWithFormat:@"%.1f万人阅读",_model.detialModel.read_count/10000.0];
    }else {
        self.readCountStr = [NSString stringWithFormat:@"%d人阅读",_model.detialModel.read_count];
    }
    _height = _height + 10 + 5;
}
// 底部的三个按钮
- (void)hn_actionLayout {
    _height = _height + 40 + hn_cell_bottom_margin + 15;
}
MJCodingImplementation
+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"hn_content"];
}


@end
