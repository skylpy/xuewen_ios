//
//  ContactTabCell.h
//  XueWen
//
//  Created by Karron Su on 2018/4/23.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface ContactTabCell : UITableViewCell

@property (nonatomic, strong) ContactModel *model;

/** 是否在多选状态*/
@property (nonatomic, assign) BOOL isMultiple;

@end
