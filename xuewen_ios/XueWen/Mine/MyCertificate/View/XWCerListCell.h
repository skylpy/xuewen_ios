//
//  XWCerListCell.h
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCertificateModel.h"

@interface XWCerListCell : UITableViewCell

@property (nonatomic,strong) XWCerListModel * model;

@end

@interface XWCerHeaderView : UIView

@property (nonatomic,strong) UILabel * titleLabel;

@end
