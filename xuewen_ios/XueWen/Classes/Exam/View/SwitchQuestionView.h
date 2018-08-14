//
//  SwitchQuestionView.h
//  XueWen
//
//  Created by ShaJin on 2018/1/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 考试界面上一题下一题View
#import <UIKit/UIKit.h>

@interface SwitchQuestionView : UIView

@property (nonatomic, assign) BOOL hasLastQuestion;
@property (nonatomic, assign) BOOL hasNextQuestion;

- (instancetype)initWithTarget:(id)target lastQuestion:(SEL)lastQuestion nextQuestion:(SEL)nextQuestion;
@end
