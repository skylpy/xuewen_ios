//
//  ClassTestViewController.h
//  XueWen
//
//  Created by ShaJin on 2018/1/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 新的课程测试界面，用于替换ExamViewController
#import "XWBaseViewController.h"
#import "XWTestEduModel.h"
@class QuestionsModel;
@interface ClassTestViewController : XWBaseViewController

@property (nonatomic,assign) BOOL eduType;

- (instancetype)initWithQuestions:(NSArray<QuestionsModel *> *)questions withTest:(BOOL)isTest withAtid:(NSString *)a_t_id;

@property (nonatomic, strong) NSString *testId;
@property (nonatomic,strong) XWTestEduModel * model;

@end
