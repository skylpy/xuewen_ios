//
//  AreaModel.h
//  XueWen
//
//  Created by ShaJin on 2017/11/24.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AreaModel : NSObject
/** 区名称 */
@property (nonatomic, strong) NSString *areaName;
/** 区ID */
@property (nonatomic, strong) NSString *areaID;
/** 所属城市ID */
@property (nonatomic, strong) NSString *cityId;
@end


@interface CityModel : NSObject
/** 城市名 */
@property (nonatomic, strong) NSString *cityName;
/** 城市ID */
@property (nonatomic, strong) NSString *cityID;
/** 首字母 */
@property (nonatomic, strong) NSString *letter;
/** 所属省ID */
@property (nonatomic, strong) NSString *provinceId;
/** 邮政编码 */
@property (nonatomic, strong) NSString *zipcode;
/** 区 */
@property (nonatomic, strong) NSArray<AreaModel *> *districts;
/**  */
@property (nonatomic, strong) NSString *isHot;
/**  */
@property (nonatomic, strong) NSString *isOpen;
@end


@interface ProvinceModel : NSObject
/** 省ID */
@property(nonatomic,strong)NSString *provinceID;
/** 省名 */
@property(nonatomic,strong)NSString *provinceName;
/** 省编码 */
@property(nonatomic,strong)NSString *provinceCode;
/** 首字母 */
@property(nonatomic,strong)NSString *letter;
/**  */
@property(nonatomic,strong)NSString *isOpen;
/** 城市 */
@property(nonatomic,strong)NSArray<CityModel *> *cities;
@end
