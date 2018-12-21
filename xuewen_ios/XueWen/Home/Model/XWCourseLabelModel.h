//
//  XWCourseLabelModel.h
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 首页标签Model*/
@interface XWCourseLabelModel : NSObject

/** 标签id*/
@property (nonatomic, strong) NSString *labelId;
/** 标签名*/
@property (nonatomic, strong) NSString *labelName;
/** 上级id*/
@property (nonatomic, strong) NSString *pid;
/** 排序*/
@property (nonatomic, strong) NSString *sort;
/** 图片名称*/
@property (nonatomic, strong) NSString *labelPictureAll;
/** */
@property (nonatomic, strong) NSString *labelPicture;
/** */
@property (nonatomic, strong) NSString *coverAll;
@property (nonatomic, strong) NSString *cover;
@end
