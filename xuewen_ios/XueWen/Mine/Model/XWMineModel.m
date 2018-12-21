//
//  XWMineModel.m
//  XueWen
//
//  Created by aaron on 2018/11/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWMineModel.h"
#import "XWHttpBaseModel.h"

@implementation XWMineModel

+ (NSArray *)sharemineHide:(NSInteger)hide {
    
    NSArray * array ;
    
    if (hide == 1) {
        XWMineModel * model1 = [XWMineModel mineTitle:@"我的证书" withSubtitle:@"" withImage:@"certificate" withController:@"XWMyCertificateViewController"];
        
        XWMineModel * model2 = [XWMineModel mineTitle:@"我的钱包" withSubtitle:[NSString stringWithFormat:@"￥%@",[XWInstance shareInstance].userInfo.gold] withImage:@"iconMoney" withController:@"MyWalletViewController"];
        
        XWMineModel * model4 = [XWMineModel mineTitle:@"我的订单" withSubtitle:@"" withImage:@"icoOrder" withController:@"PurchaseRecordViewController"];
        
        XWMineModel * model5 = [XWMineModel mineTitle:@"邀请有礼" withSubtitle:@"" withImage:@"icoInvitation" withController:@"InvitationViewController"];
        
        XWMineModel * model6 = [XWMineModel mineTitle:@"个人设置" withSubtitle:@"" withImage:@"icoSetUp-1" withController:@"SettingViewController"];
        
        XWMineModel * model7 = [XWMineModel mineTitle:@"用户反馈" withSubtitle:@"" withImage:@"icoNote" withController:@"XWFeedBackViewController"];
        
        array = @[model1,model2,model4,model5,model6,model7];
    }else {
        XWMineModel * model1 = [XWMineModel mineTitle:@"我的证书" withSubtitle:@"" withImage:@"certificate" withController:@"XWMyCertificateViewController"];
        XWMineModel * model2 = [XWMineModel mineTitle:@"我的钱包" withSubtitle:[NSString stringWithFormat:@"￥%@",[XWInstance shareInstance].userInfo.gold] withImage:@"iconMoney" withController:@"MyWalletViewController"];
        XWMineModel * model3 = [XWMineModel mineTitle:@"我的奖学金" withSubtitle:[NSString stringWithFormat:@"￥%@",[XWInstance shareInstance].userInfo.user_coupon] withImage:@"icoCoupon" withController:@"MyCouponViewController"];
        XWMineModel * model4 = [XWMineModel mineTitle:@"我的订单" withSubtitle:@"" withImage:@"icoOrder" withController:@"PurchaseRecordViewController"];
        XWMineModel * model5 = [XWMineModel mineTitle:@"邀请有礼" withSubtitle:@"邀请1人得30元" withImage:@"icoInvitation" withController:@"InvitationViewController"];
        XWMineModel * model6 = [XWMineModel mineTitle:@"个人设置" withSubtitle:@"" withImage:@"icoSetUp-1" withController:@"SettingViewController"];
        XWMineModel * model7 = [XWMineModel mineTitle:@"用户反馈" withSubtitle:@"" withImage:@"icoNote" withController:@"XWFeedBackViewController"];
        
        array = @[model1,model2,model3,model4,model5,model6,model7];
    }
    
    XWMineModel * model8 = [XWMineModel mineTitle:@"企业管理" withSubtitle:@"" withImage:@"ico_admin" withController:@"XWCompanyManageViewController"];
    NSMutableArray *dataSource = [array mutableCopy];
    if ([[XWInstance shareInstance].userInfo.company_status isEqualToString:@"1"]) {
        [dataSource addObject:model8];
    }
    
    return dataSource;
}

+ (XWMineModel *)mineTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImage:(NSString *)imageStr withController:(NSString *)controller{
    
    XWMineModel * model = [XWMineModel new];
    model.title = title;
    model.subtitle = subtitle;
    model.imageStr = imageStr;
    model.controller = controller;
    return model;
}

//我的页面控制
+ (void)mineVersion:(NSString *)version
            success:(void(^)(NSInteger hide))success
            failure:(void(^)(NSString *error))failure {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:version forKey:@"version"];
    [XWHttpBaseModel BGET:BASE_URL(StoreIsHide) parameters:dic extra:0 success:^(XWHttpBaseModel *model) {
        
        NSString * version = model.data[@"isHide"];
        !success?:success([version integerValue]);
        
    } failure:^(NSString *error) {
        
        
    }];
}

@end
