//
//  XWMyCertificateCell.h
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCertificateModel.h"

@interface XWMyCertificateCell : UITableViewCell

@property (nonatomic,strong) XWCerDataModel * model;
@property (nonatomic,copy) void (^didSelectCerClick)(XWCerChildrenModel * chModel);


@end
