//
//  XWBannerManagerCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/10.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBannerManagerCell.h"
#import "XWHttpBaseModel.h"

@interface XWBannerManagerCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgIcon;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addIcon;

@end

@implementation XWBannerManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView rounded:0 width:1 color:Color(@"#DDDDDD")];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter
- (void)setIsLastCell:(BOOL)isLastCell {
    _isLastCell = isLastCell;
    if (_isLastCell) {
        self.addIcon.hidden = NO;
        self.bgIcon.hidden = YES;
        self.deleteBtn.hidden = YES;
    }else {
        self.addIcon.hidden = YES;
        self.bgIcon.hidden = NO;
        self.deleteBtn.hidden = NO;
    }
}

- (void)setBanner:(BannerModel *)banner {
    _banner = banner;
    [self.bgIcon sd_setImageWithURL:[NSURL URLWithString:banner.picture]];
}

#pragma mark - Action
- (IBAction)deleteBtnClick:(UIButton *)sender {
    XWWeakSelf
    [UIAlertController alertControllerTwo:self.viewController withTitle:@"要删除这张图片吗?" withMessage:@"" withConfirm:@"取消" withCancel:@"确定" actionConfirm:^{
        
    } actionCancel:^{
        [weakSelf deleteBanner];
    }];
}

#pragma mark - Custom Methods
- (void)deleteBanner {
    [XWHttpBaseModel BDELETE:kBASE_URL(ShufflingFigure, _banner.imageID) parameters:nil extra:0 success:^(XWHttpBaseModel *model) {
        [self postNotificationWithName:@"UpdateBannerManager" object:nil];
    } failure:^(NSString *error) {
        NSLog(@"error is %@", error);
    }];
}

@end
