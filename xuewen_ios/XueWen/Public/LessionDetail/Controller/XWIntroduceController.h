//
//  XWIntroduceController.h
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"
#import "XWCoursInfoModel.h"
#import "LessionDetailDelegate.h"


@interface XWIntroduceController : XWBaseViewController

@property (nonatomic, strong) XWCoursInfoModel *model;

@property (nonatomic, weak) id<LessionDetailDelegate> delegate;

@property (nonatomic, assign) BOOL isAudio;

@end
