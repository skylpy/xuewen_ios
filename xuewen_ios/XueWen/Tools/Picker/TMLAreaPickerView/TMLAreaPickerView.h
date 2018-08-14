//
//  TMLAreaPickerViewController.h
//  TMLBanner(OC)
//
//  Created by charles on 2017/6/12.
//  Copyright © 2017年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaPickerModel : NSObject

/** 省份 */
@property (copy, nonatomic) NSString *province;
/** 城市 */
@property (copy, nonatomic) NSString *city;
/** 区域 */
@property (copy, nonatomic) NSString *area;



@end


@interface TMLAreaPickerView : UIView
@property(nonatomic,copy)void (^CompleteBlock)(NSDictionary *dict);

// 初始化方法
- (instancetype)initAreaPickerWithDataSource:(NSArray *)dataSource;

/**
 * 初始化方法
 */
- (instancetype) initAreaPickerWithCompleteBlock:(void(^)(AreaPickerModel *))completeBlock;
/**
 * 弹出方法
 */
- (void)show;

@end
