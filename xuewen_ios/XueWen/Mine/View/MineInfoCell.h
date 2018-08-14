//
//  MineInfoCell.h
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInfoCell : UITableViewCell

@property (nonatomic, assign) BOOL isFirst;

- (void)setTitle:(NSString *)title content:(NSString *)content type:(NSInteger)type canEdit:(BOOL)canEdit;
- (void)setHeaderImage:(UIImage *)image;
- (void)setContent:(NSString *)content;

@end
