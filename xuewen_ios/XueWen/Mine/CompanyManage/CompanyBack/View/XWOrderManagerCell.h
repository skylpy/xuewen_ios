//
//  XWOrderManagerCell.h
//  XueWen
//
//  Created by aaron on 2018/12/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCompanyBackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XWOrderManagerCell : UITableViewCell

@property (nonatomic,strong) XWCompanyOrderModel * model;

@property (nonatomic,copy) void (^payButtonClick)(XWCompanyOrderModel * pmodel);
@property (nonatomic,copy) void (^canceButtonClick)(XWCompanyOrderModel * pmodel);

@end

NS_ASSUME_NONNULL_END
