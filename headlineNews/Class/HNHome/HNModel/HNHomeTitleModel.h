//
//  HNHomeTitleModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/28.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
//category = "news_hot";
//"concern_id" = "";
//"default_add" = 1;
//flags = 0;
//"icon_url" = "";
//name = "\U70ed\U70b9";
//"tip_new" = 0;
//type = 4;
//"web_url" = "";
@interface HNHomeTitleModel : NSObject

@property (nonatomic , copy)NSString *category;

@property (nonatomic , copy)NSString *concern_id;

@property (nonatomic , assign)int default_add;

@property (nonatomic , assign)int flags;

@property (nonatomic , copy)NSString *icon_url;

@property (nonatomic , copy)NSString *name;

@end
