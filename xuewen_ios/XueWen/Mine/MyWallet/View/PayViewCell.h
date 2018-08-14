//
//  PayViewCell.h
//  XueWen
//
//  Created by ShaJin on 2017/12/8.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewCell : UITableViewCell

@property (nonatomic, assign) BOOL canSelect;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isFirst;
- (void)setTitle:(NSString *)title content:(NSString *)content icon:(UIImage *)icon;

@end
