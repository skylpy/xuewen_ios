//
//  ExamViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/12/11.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 旧的课程测试界面，现在只用于展示考试结果，有些逻辑看起来有些奇怪是因为之前此页面用于课程测试
#import "XWBaseViewController.h"
@class QuestionsModel;
@interface ExamViewController : XWBaseViewController

@property (nonatomic, assign) BOOL showAll;

- (instancetype)initWithQuestions:(NSArray<QuestionsModel *> *)questions errorOnly:(BOOL)errorOnly;

@end
