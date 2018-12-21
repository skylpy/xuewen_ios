//
//  XWEduTestResultViewController.h
//  XueWen
//
//  Created by aaron on 2018/10/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"
#import "XWTestEduModel.h"
NS_ASSUME_NONNULL_BEGIN
@class QuestionsModel;
@interface XWEduTestResultViewController : XWBaseViewController

- (instancetype)initWithQuestions:(NSArray<QuestionsModel *> *)questions withTest:(BOOL)isTest withAtid:(NSString *)atid;
@property (nonatomic,copy) NSString * atid;
@property (nonatomic, strong) NSString *testId;
@property (nonatomic,strong) XWTestEduModel * tmodel;

@end

NS_ASSUME_NONNULL_END
