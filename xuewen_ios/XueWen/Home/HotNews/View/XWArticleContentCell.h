//
//  XWArticleContentCell.h
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWArticleContentModel.h"

@interface XWArticleContentCell : UITableViewCell

@property (nonatomic, strong) XWArticleContentModel *model;
@property (nonatomic, assign) CGFloat cellHeight;

@end
