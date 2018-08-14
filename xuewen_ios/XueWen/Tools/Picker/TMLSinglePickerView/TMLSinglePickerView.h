//
//  TMLPickerView.h
//  happyselling
//
//  Created by charles on 2017/6/20.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMLPickerModel.h"

@interface TMLSinglePickerView : UIView

- (instancetype) initPickerArray:(NSMutableArray *)arr WithCompleteBlock:(void(^)(TMLPickerModel * model))completeBlock;

- (instancetype)initPickerArray:(NSMutableArray *)arr WithCompleteIndexBlock:(void(^)(NSInteger row))completeBlock;

// 新的方法，带有默认选项的 2018.01.30
- (instancetype)initPickerArray:(NSMutableArray *)arr defaultPick:(NSString *)sex WithCompleteBlock:(void(^)(TMLPickerModel * model))completeBlock;
- (void)show;
@end
