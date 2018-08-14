//
//  XWArticleContentModel.h
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 文章-单个内容Model*/
@interface XWArticleContentModel : NSObject

/** 数据(文章)id*/
@property (nonatomic, strong) NSString *articleId;
/** 来源0无1微信抓取*/
@property (nonatomic, strong) NSString *source;
/** 上上级标签ID*/
@property (nonatomic, strong) NSString *classFid;
/** 上级标签ID*/
@property (nonatomic, strong) NSString *classid;
/** 作者*/
@property (nonatomic, strong) NSString *author;
/** 版权统计*/
@property (nonatomic, strong) NSString *copyrightStat;
/** 更新时间*/
@property (nonatomic, strong) NSString *updateTime;
/** 创建时间*/
@property (nonatomic, strong) NSString *createTime;
/** 标题*/
@property (nonatomic, strong) NSString *title;
/** 摘要*/
@property (nonatomic, strong) NSString *digest;
/** 内容链接*/
@property (nonatomic, strong) NSString *contentUrl;
/** 封面图*/
@property (nonatomic, strong) NSString *cover;
/** 公众号名称*/
@property (nonatomic, strong) NSString *wechatname;
/** 文章内容*/
@property (nonatomic, strong) NSString *contentHtml;
/** 点击数*/
@property (nonatomic, strong) NSString *click;
/** 排序值*/
@property (nonatomic, strong) NSString *sort;
/** 是否显示*/
@property (nonatomic, strong) NSString *isShow;






@end
