//
//  CourseNoteModel.h
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CourseNoteModel : NSObject
/** 笔记ID*/
@property (nonatomic, strong) NSString *noteID;
/** 课程ID */
@property (nonatomic, strong) NSString *courseID;
/** 课程名称 */
@property (nonatomic, strong) NSString *courseName;
/** 笔记内容 */
@property (nonatomic, strong) NSString *content;
/** 记笔记时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 创建日期 */
@property (nonatomic, strong) NSString *creatDate;
/** 记笔记人头像 */
@property (nonatomic, strong) NSString *picture;
/** 记笔记人昵称 */
@property (nonatomic, strong) NSString *nickName;
/** 记笔记人组织（公司）ID */
@property (nonatomic, strong) NSString *companyID;
/** 笔记类型0公开1企业笔记2我的笔记 */
@property (nonatomic, strong) NSString *status;
/** 是否展示全部内容 */
@property (nonatomic, assign) BOOL showAll;
@end
