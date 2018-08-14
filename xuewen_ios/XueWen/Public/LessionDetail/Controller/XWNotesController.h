//
//  XWNotesController.h
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"
#import "LessionDetailDelegate.h"

@interface XWNotesController : XWBaseViewController

- (instancetype)initWithCoursId:(NSString *)courseID isNotes:(BOOL)isNotes;

// 是否购买了该课程
@property (nonatomic, strong) NSString *type;

@property(nonatomic,weak)id<LessionDetailDelegate> delegate;


- (void)reloadData;

@end
