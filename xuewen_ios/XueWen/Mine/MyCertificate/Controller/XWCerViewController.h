//
//  XWCerViewController.h
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"
#import "XWCertificateModel.h"

@interface XWCerViewController : XWBaseViewController
//从证书列表传入
@property (nonatomic) XWCerListModel * lmodel;
//从考试结果传入
@property (nonatomic) XWCertificateModel * model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
//事业
@property (weak, nonatomic) IBOutlet UILabel *causeLabel;
//证书编号
@property (weak, nonatomic) IBOutlet UILabel *cerNumberLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)shareBtnClick;

@end
