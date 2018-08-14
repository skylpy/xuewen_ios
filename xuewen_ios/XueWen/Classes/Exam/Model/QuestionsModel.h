//
//  QuestionsModel.h
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 选项模型 */
@interface QuestionsOptionModel : NSObject
/** 试题ID */
@property (nonatomic, strong) NSString *questionsID;
/** 选项ID */
@property (nonatomic, strong) NSString *optionID;
/** 是否正确（0否1是） */
@property (nonatomic, assign) BOOL right;
@property (nonatomic, strong) NSString *correct;
/** 选项标题 */
@property (nonatomic, strong) NSString *title;
/** 选项内容 */
@property (nonatomic, strong) NSString *content;
/** 是否选中 string类型的是上传下载时用到的属性 bool类型的是程序中用到的属性*/
@property (nonatomic, strong) NSString *select;
@property (nonatomic, assign) BOOL isSelected;

@end



/** 试题模型 */
@interface QuestionsModel : NSObject
/** 试卷所属课程ID */
@property (nonatomic, strong) NSString *courseID;
/** 试卷ID */
@property (nonatomic, strong) NSString *testID;
/** 试题ID */
@property (nonatomic, strong) NSString *questionsID;
/** 试题类型0单选：1多选 这个是上传/下载时用到的属性 */
@property (nonatomic, strong) NSString *type;
/** 试题类型 同上 这个是程序中用到的属性 */
@property (nonatomic, assign) BOOL multiSelect;
/** 题干 */
@property (nonatomic, strong) NSString *title;
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 创建时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 选项 */
@property (nonatomic, strong) NSArray<QuestionsOptionModel *> *options;
/** 是否已经选择 这个是程序中用到的属性*/
@property (nonatomic, assign) BOOL commited;
/** 是否已经选择，这个是上传时用到的属性 */
@property (nonatomic, strong) NSString *hasCommit;
@end
