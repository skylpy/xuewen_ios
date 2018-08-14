//
//  CommonModel.h
//  XueWen
//
//  Created by ShaJin on 2017/11/28.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 评论模型 */
@interface CommonModel : NSObject
/*
 "comment": "合适的快捷回复可见当时跟客户",
 "create_time": 1511765673,
 "picture": null,
 "nick_name": "心跳"
 */
/** 评论者昵称 */
@property (nonatomic, strong) NSString *nickName;
/** 评论者头像 */
@property (nonatomic, strong) NSString *picture;
/** 评论内容 */
@property (nonatomic, strong) NSString *comment;
/** 评论时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 内容太长时是否展开全部内容 */
@property (nonatomic, assign) BOOL showAll;
@end
