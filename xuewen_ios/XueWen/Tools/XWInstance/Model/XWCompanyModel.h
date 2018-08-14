//
//  XWCompanyModel.h
//  XueWen
//
//  Created by ShaJin on 2017/11/23.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWCompanyModel : NSObject
/** 公司ID */
@property (nonatomic, strong) NSString *oid;
/** 公司名称 */
@property (nonatomic, strong) NSString *name;
/** 联系电话 */
@property (nonatomic, strong) NSString *phoneNumber;
/** 地址 */
@property (nonatomic, strong) NSString *addres;
/** 联系人 */
@property (nonatomic, strong) NSString *contacts;
/** 公司简介 */
@property (nonatomic, strong) NSString *introduction;
@end
