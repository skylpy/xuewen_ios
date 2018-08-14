//
//  XWCommentModel.h
//  XueWen
//
//  Created by Karron Su on 2018/5/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 讨论Model*/
@interface XWCommentModel : NSObject

/** 评论内容*/
@property (nonatomic, strong) NSString *comment;
/** 评论时间*/
@property (nonatomic, strong) NSString *createTime;
/** 用户头像*/
@property (nonatomic, strong) NSString *picture;
/** 用户昵称*/
@property (nonatomic, strong) NSString *nickName;
/** （域名加用户头像）*/
@property (nonatomic, strong) NSString *pictureAll;
@end
