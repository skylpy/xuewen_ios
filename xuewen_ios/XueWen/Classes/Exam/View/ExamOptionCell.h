//
//  ExamOptionCell.h
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger) {
    kDefaultState,
    kSelectState,
    kWrongState,
}SelectState;
@class QuestionsOptionModel;
@interface ExamOptionCell : UITableViewCell

@property (nonatomic, assign) SelectState state;
@property (nonatomic, strong) QuestionsOptionModel *model;

- (void)setModel:(QuestionsOptionModel *)model hasCommit:(BOOL)hasCommit;

@end
