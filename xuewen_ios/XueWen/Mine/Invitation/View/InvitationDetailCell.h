//
//  InvitationDetailCell.h
//  XueWen
//
//  Created by ShaJin on 2018/3/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvitationedModel;
@class InvitationPersonalModel;
@interface InvitationDetailCell : UITableViewCell

@property (nonatomic, strong) InvitationedModel *model;
@property (nonatomic, strong) InvitationPersonalModel *personalModel;

@end
