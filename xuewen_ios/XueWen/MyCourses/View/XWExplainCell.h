//
//  XWExplainCell.h
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWExplainCell : UITableViewCell

@property (nonatomic,strong) XWMyPlanModel *model;

@property (nonatomic,strong) void (^histroyClick)(void);
@property (nonatomic,strong) void (^noteClick)(void);
@property (nonatomic,strong) void (^testClick)(void);
@end
