//
//  XWBannerManagerCell.h
//  XueWen
//
//  Created by Karron Su on 2018/12/10.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XWBannerManagerCell : UITableViewCell

@property (nonatomic, strong) BannerModel *banner;
@property (nonatomic, assign) BOOL isLastCell;

@end

NS_ASSUME_NONNULL_END
