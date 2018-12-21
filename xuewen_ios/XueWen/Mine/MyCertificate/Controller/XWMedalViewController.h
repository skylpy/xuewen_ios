//
//  XWMedalViewController.h
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"
#import "XWCertificateModel.h"

@class XWQRCodeView;
@interface XWMedalViewController : XWBaseViewController

@property (nonatomic) XWCerListModel * model;
//描述
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
//勋章icon
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//职业
@property (weak, nonatomic) IBOutlet UILabel *causeLabel;
//认证
@property (weak, nonatomic) IBOutlet UILabel *cerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconURLImage;
//二维码
@property (strong,nonatomic) XWQRCodeView * codeView;

- (void)shareBtnClick;

@end
