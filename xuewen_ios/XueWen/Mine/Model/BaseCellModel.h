//
//  BaseCellModel.h
//  XueWen
//
//  Created by Pingzi on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "BaseJsonModel.h"

@interface BaseCellModel : BaseJsonModel

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *LeftTitle;

@property (nonatomic, strong) NSString *rightDetail;

@property (nonatomic, strong) NSString *placeHolder;

@end
