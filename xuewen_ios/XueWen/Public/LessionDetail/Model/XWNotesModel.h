//
//  XWNotesModel.h
//  XueWen
//
//  Created by Karron Su on 2018/5/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 笔记Model*/
@interface XWNotesModel : NSObject

@property (nonatomic, strong) NSString *noteID;
@property (nonatomic, strong) NSString *CourseID;
@property (nonatomic, strong) NSString *noteContent;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *pictureAll;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *companyID;
@property (nonatomic, strong) NSString *ststus;
@property (nonatomic, strong) NSString *sex;

@end
