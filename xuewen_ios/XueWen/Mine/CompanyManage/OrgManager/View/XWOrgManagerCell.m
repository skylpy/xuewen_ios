//
//  XWOrgManagerCell.m
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWOrgManagerCell.h"

@interface XWOrgManagerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *normalLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postName;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout;


@end

@implementation XWOrgManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.roleLabel.hidden = YES;
    self.addBtn.hidden = YES;
    [self.headIcon rounded:20];
    self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter
- (void)setModel:(XWOrgManagerModel *)model {
    _model = model;
    self.titleLabel.text = _model.name;
    if ([_model.post isEqualToString:@""] || _model.post == nil) {
        self.postName.hidden = YES;
        self.layout.constant = 10;
    }else {
        self.postName.hidden = NO;
        self.postName.text = _model.post;
        self.layout.constant = 2;
    }
    
    if ([_model.pictureAll isEqualToString:@""] || _model.pictureAll == nil) {
        self.normalLabel.hidden = NO;
        NSString *text;
        if (_model.name.length >= 2) {
            text = [_model.name substringFromIndex:_model.name.length - 2];
        }else {
            text = _model.name;
        }
        self.normalLabel.text = text;
    }else {
        self.normalLabel.hidden = YES;
    }
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:_model.pictureAll]];
}

- (void)setIsDepartment:(BOOL)isDepartment {
    _isDepartment = isDepartment;
    if (_isDepartment) {
        self.roleLabel.hidden = NO;
        self.addBtn.hidden = YES;
    }else {
        self.roleLabel.hidden = YES;
        self.addBtn.hidden = YES;
    }
}

- (void)setIsHome:(BOOL)isHome {
    _isHome = isHome;
    if (_isHome) {
        self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 30);
    }else {
        self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
    }
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    if (_isLast) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else {
        if (_isHome) {
            self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 30);
        }else {
            self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
        }
    }
}

- (void)setUser:(XWDepartmentUserModel *)user {
    _user = user;
    self.titleLabel.text = _user.name;
    if ([_user.post isEqualToString:@""] || _user.post == nil) {
        self.postName.hidden = YES;
        self.layout.constant = 10;
    }else {
        self.postName.hidden = NO;
        self.postName.text = _user.post;
        self.layout.constant = 2;
    }
    
    if (_user.isSelect) {
        self.normalLabel.hidden = YES;
        self.headIcon.contentMode = UIViewContentModeCenter;
        self.headIcon.image = LoadImage(@"gouxuanico");
    }else {
        if ([_user.picture isEqualToString:@""] || _user.picture == nil) {
            self.normalLabel.hidden = NO;
            NSString *text;
            if (_user.name.length >= 2) {
                text = [_user.name substringFromIndex:_user.name.length - 2];
            }else {
                text = _user.name;
            }
            self.normalLabel.text = text;
        }else {
            self.normalLabel.hidden = YES;
        }
        self.headIcon.contentMode = UIViewContentModeScaleToFill;
        [self.headIcon sd_setImageWithURL:[NSURL URLWithString:_user.picture]];
    }
}

@end
