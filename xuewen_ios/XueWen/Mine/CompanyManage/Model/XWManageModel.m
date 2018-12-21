//
//  XWManageModel.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWManageModel.h"

@implementation XWManageModel

+ (NSArray *)shareManage {
    
    XWManageModel * model1 = [XWManageModel manageTitle:@"企业数据" withImage:@"icolist01" withController:@""];
    
    XWManageModel * model2 = [XWManageModel manageTitle:@"课程管理" withImage:@"icolist02" withController:@"XWCourseManageViewController"];
    
    XWManageModel * model3 = [XWManageModel manageTitle:@"组织管理"  withImage:@"icolist03" withController:@"XWOrganizationManagerViewController"];
    
    XWManageModel * model4 = [XWManageModel manageTitle:@"学习管理" withImage:@"icolist04" withController:@""];
    
    XWManageModel * model5 = [XWManageModel manageTitle:@"企业钱包" withImage:@"icolist05" withController:@"XWCompanyBackViewController"];
    
    XWManageModel * model6 = [XWManageModel manageTitle:@"岗位能力认证" withImage:@"icolist06" withController:@""];
    
    NSArray * array = @[model1,model2,model3,model4,model5,model6];
//    NSArray * array = @[model2,model3,model4,model5];
    return array;
}

+ (NSArray *)shareManageBack {
    
    XWManageModel * model1 = [XWManageModel manageTitle:@"订单管理" withImage:@"icolist051" withController:@"XWOrderManagerViewController"];
    
    XWManageModel * model2 = [XWManageModel manageTitle:@"奖学金" withImage:@"icolist061" withController:@"XWScholarShipViewController"];
    
    return @[model1,model2];
}

+ (XWManageModel *)manageTitle:(NSString *)title withImage:(NSString *)imageStr withController:(NSString *)controller{
    
    XWManageModel * model = [[XWManageModel alloc] init];
    model.title = title;
    model.imageStr = imageStr;
    model.controller = controller;
    return model;
}

@end
