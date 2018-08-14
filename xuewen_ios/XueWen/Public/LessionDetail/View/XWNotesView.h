//
//  XWNotesView.h
//  XueWen
//
//  Created by aaron on 2018/7/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "EScrollPageView.h"
#import "LessionDetailDelegate.h"

@interface XWNotesView : EScrollPageItemBaseView

- (void)initWithCoursId:(NSString *)courseID isNotes:(BOOL)isNotes;

// 是否购买了该课程
@property (nonatomic, strong) NSString *type;

@property(nonatomic,weak)id<LessionDetailDelegate> delegate;


- (void)reloadData;

@end
