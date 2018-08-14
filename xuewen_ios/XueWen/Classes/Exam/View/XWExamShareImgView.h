//
//  XWExamShareImgView.h
//  XueWen
//
//  Created by Karron Su on 2018/7/4.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWExamShareInfoModel.h"

@interface XWExamShareImgView : UIView

@property (nonatomic, strong) UIImage *QRImage;  // 邀请注册二维码
@property (nonatomic, assign) NSInteger score;   // 分数
@property (nonatomic, strong) XWExamShareInfoModel *model;

@end
