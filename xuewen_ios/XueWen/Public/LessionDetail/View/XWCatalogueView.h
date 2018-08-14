//
//  XWCatalogueView.h
//  XueWen
//
//  Created by Karron Su on 2018/5/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWAudioNodeModel.h"
#import "XWCoursInfoModel.h"

#pragma mark - 自定义cell

@interface XWCatalogueTableCell : UITableViewCell

@property (nonatomic, strong) XWAudioNodeModel *model;

@property (nonatomic, assign) BOOL isAudio;

@property (nonatomic, strong) XWCoursInfoModel *infoModel;

@end

#pragma mark - 目录VIew

@interface XWCatalogueView : UIView

- (instancetype)initWithDataArray:(NSMutableArray *)dataArray doBlock:(void(^)(NSInteger selectedIndex))doBlock playIndex:(NSInteger)playIndex infoModel:(XWCoursInfoModel *)infoModel isAudio:(BOOL)isAudio;

@end
