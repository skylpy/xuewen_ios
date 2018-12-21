//
//  XWProjectHeaderView.h
//  XueWen
//
//  Created by Karron Su on 2018/8/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"

@interface XWProjectHeaderView : UIView

@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, strong) NSString *projectName;

@end
