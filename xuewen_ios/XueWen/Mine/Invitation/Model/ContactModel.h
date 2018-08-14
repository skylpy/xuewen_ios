//
//  ContactModel.h
//  XueWen
//
//  Created by Karron Su on 2018/4/23.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 通讯录Model*/
@interface ContactModel : NSObject

/** 名称*/
@property (nonatomic, strong) NSString *name;
/** 电话号码*/
@property (nonatomic, strong) NSString *phoneNumber;
/** 首字母*/
@property (nonatomic, strong) NSString *first;
/** 是否被选中*/
@property (nonatomic, assign) BOOL isChoice;



@end
