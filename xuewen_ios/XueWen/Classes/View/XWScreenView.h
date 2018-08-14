//
//  XWScreenView.h
//  XueWen
//
//  Created by ShaJin on 2018/1/15.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "BaseAlertView.h"
@protocol XWScreenDelegate <NSObject>

- (void)confirmWithSort:(NSString *)sort pay:(NSString *)pay type:(NSString *)type labelID:(NSString *)labelID;

@end
@interface XWScreenView : BaseAlertView
- (instancetype)initWithLabelID:(NSString *)labelID;
- (void)showWithSort:(NSString *)sort pay:(NSString *)pay type:(NSString *)type labelID:(NSString *)labelID;
@property (nonatomic, weak) id<XWScreenDelegate> delegate;

@end
