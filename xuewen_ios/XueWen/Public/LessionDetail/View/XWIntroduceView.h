//
//  XWIntroduceView.h
//  XueWen
//
//  Created by aaron on 2018/7/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "EScrollPageView.h"
#import "LessionDetailDelegate.h"
//@class EScrollPageItemBaseView;

@interface XWIntroduceView : EScrollPageItemBaseView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) XWCoursInfoModel *model;

@property (nonatomic, weak) id<LessionDetailDelegate> delegate;

@property (nonatomic, assign) BOOL isAudio;

@end
