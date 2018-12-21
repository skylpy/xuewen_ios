//
//  XWStudyRankView.h
//  XueWen
//
//  Created by Karron Su on 2018/7/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "EScrollPageView.h"
#import "XWCountPlayTimeModel.h"
#import "XWTargetRankModel.h"

@interface XWStudyRankView : EScrollPageItemBaseView

@property(nonatomic,retain)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *studyArray;

@property (nonatomic, strong) XWCountPlayTimeModel *rankModel;

@property (nonatomic, strong) NSMutableArray *targetArray;

@property (nonatomic, strong) XWTargetRankModel *targetModel;

@property (nonatomic, assign) BOOL isMyCompany;

@end
