//
//  XWPopMenuView.h
//  XueWen
//
//  Created by Karron Su on 2018/5/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 数据Model

@interface XWPopMenuModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selected;

@end

#pragma mark - 自定义cell

@interface XWpopMenuTableCell : UITableViewCell

@property (nonatomic, strong) XWPopMenuModel *model;

@end

#pragma mark - PopView

@interface XWPopMenuView : UIView

- (instancetype)initWithTitleArray:(NSArray *)titleArray selectedIndex:(NSInteger)selectedIndex doBlock:(void(^)(NSInteger selectedIndex))doBlock dismissBlock:(void(^)(void))dismissBlock;

@end







