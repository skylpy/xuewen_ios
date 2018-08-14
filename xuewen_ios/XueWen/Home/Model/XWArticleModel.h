//
//  XWArticleModel.h
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 文章Model*/
@interface XWArticleModel : NSObject

/** 文章id*/
@property (nonatomic, strong) NSString *articleId;
/** 文章标题*/
@property (nonatomic, strong) NSString *title;
/** 时间*/
@property (nonatomic, strong) NSString *updateTime;
/** 添加时间*/
@property (nonatomic, strong) NSString *createTime;

@end
