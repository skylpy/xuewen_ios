//
//  XWCertificateCell.h
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCertificateModel.h"

@interface XWCertificateCell : UICollectionViewCell

@property (nonatomic,strong) XWCerChildrenModel * model;
@property (nonatomic,copy) NSString * icon;

@end
