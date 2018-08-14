//
//  InvitationDetailListViewController.h
//  XueWen
//
//  Created by ShaJin on 2018/3/29.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWListViewController.h"

@interface InvitationDetailListViewController : XWListViewController

@property (nonatomic, strong) NSString *date;

- (instancetype)initWithCompany:(BOOL)company;

@end
