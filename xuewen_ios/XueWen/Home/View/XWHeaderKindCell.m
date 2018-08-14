//
//  XWHeaderKindCell.m
//  XueWen
//
//  Created by Karron Su on 2018/4/25.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHeaderKindCell.h"
#import "XWAudioCourseListController.h"
#import "XWShopViewController.h"

@implementation XWHeaderKindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 精品课程*/
- (IBAction)jpBtnClick:(UIButton *)sender {
    [MBProgressHUD showWarnMessage:@"功能开发中,敬请期待!"];
}

/** 职场进阶*/
- (IBAction)zcBtnClick:(UIButton *)sender {
    [MBProgressHUD showWarnMessage:@"功能开发中,敬请期待!"];
}

/** 实物商城*/
- (IBAction)scBtnClick:(UIButton *)sender {

//#ifdef DEBUG
//    XWShopViewController *vc = [[XWShopViewController alloc] init];
//    vc.shopUrl = self.shopUrl;
//    [self.viewController.navigationController pushViewController:vc animated:YES];
//#else
    [MBProgressHUD showWarnMessage:@"功能开发中,敬请期待!"];
//#endif
    
     
}

/** 音频课程*/
- (IBAction)ypBtnClick:(UIButton *)sender {
    XWAudioCourseListController *vc = [[XWAudioCourseListController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
