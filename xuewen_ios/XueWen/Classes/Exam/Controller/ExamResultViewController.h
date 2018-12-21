//
//  ExamResultViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWBaseViewController.h"


@class QuestionsModel;
@interface ExamResultViewController : XWBaseViewController

- (instancetype)initWithQuestions:(NSArray<QuestionsModel *> *)questions withTest:(BOOL)isTest withAtid:(NSString *)atid;
@property (nonatomic,copy) NSString * atid;

@end
