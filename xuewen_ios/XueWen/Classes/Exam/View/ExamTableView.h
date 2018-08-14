//
//  ExamTableView.h
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionsModel;
@interface ExamTableView : UITableView

@property (nonatomic, strong) NSArray<QuestionsModel *> *questions;

- (void)commit;

@end
