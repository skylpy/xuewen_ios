//
//  XWOrderFooterView.h
//  XueWen
//
//  Created by aaron on 2018/12/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWOrderFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *sureLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *payableLabel;
+ (instancetype)shareOrderFooterView;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

NS_ASSUME_NONNULL_END
